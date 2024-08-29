library(reticulate)
library(glmnet)
library(ggplot2)
library(cowplot)
library(patchwork)
use_condaenv("c://ProgramData/Anaconda3/envs/RSCP/python.exe")
py_run_file('D:\\RSCP\\param\\cs_predict.py')

## load model
load("D:\\RSCP\\param\\RCSP_model.rdata")

data = as.data.frame(matrix(NA,nrow = nrow(py$df),ncol = ncol(py$df)))
colnames(data) = colnames(py$df);rownames(data) = rownames(py$df)
for (i in 1:nrow(py$df)) {
  for (j in 1:ncol(py$df)) {
    data[i,j] = py$df[i,j][[1]]
  }
}

for (i in setdiff(colnames(data),'id')) {
  data[i] = (data[i]-scale_matrix[i,'smean'])/scale_matrix[i,'ssd']
}

id_df = data$id
data = data[,-1]
score = round(predict(RCSP_model, newx = as.matrix(data), s = "lambda.min"),3)
score = cbind.data.frame(id_df,score)

mode = 'single'
if (mode == 'single') {
  RCSP_df = data.frame(
    Category = c("reference", "measured"),
    Value = c(0.624, score[1,2]))
  RCSP_df$Category = factor(RCSP_df$Category,levels = c("reference","measured"))
  color_mapping <- ifelse(RCSP_df$Category == "reference", "grey",
                          ifelse(RCSP_df$Value > RCSP_df$Value[RCSP_df$Category == "reference"], "blue", "red"))


  p <- ggplot(RCSP_df, aes(x = Category, y = Value, fill = Category)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = color_mapping) +
    theme_classic() +
    labs(x = "Category", y = "Value", #title = paste0('RCSP value: ',round(score[1,2],3)),
         #subtitle = paste0('cutoff: ',0.624)
         ) +
    theme(
      plot.title = element_text(hjust = 0.5,vjust = 0.5, size = 80, face = "bold"),  # 标题居中，12号字
      plot.subtitle = element_text(hjust = 1,vjust = 0.5, size = 20),
      #axis.title.x = element_text(size = 16),  # X轴标题10号字
      axis.title.x=element_blank(),
      axis.text.x = element_text(size = 10,color = "black"),
      #axis.title.y = element_text(size = 10),   # Y轴标题10号字
      axis.title.y = element_blank(),
      axis.text.y = element_text(size = 10,color = "black"),
      legend.position = 'none')+
     #+
    #geom_text(aes(label = Value))  # 在柱子上显示具体的数字
    #scale_y_continuous(limits = c(-2, 2), breaks = seq(-2, 2, by = 2)
    scale_y_continuous(breaks = 0.624)+
    geom_hline(yintercept = RCSP_df$Value[RCSP_df$Category == "reference"], linetype = "dashed", color = "black")
}



p1 = ggdraw() +
  draw_image("./param/slice_images/slice_100.jpg")

pdf('./report.pdf',width = 5.5,height = 4)
p1+p+plot_annotation(title = 'Report',
                     subtitle = paste0('ID: ',score$id_df[1],'\n',
                                       'RCSP: ',ifelse((RCSP_df$Value[1]>0.624),'High','Low'),'\n',
                                        'Value: ',round(score[1,2],3)),caption = paste0('High RCSP: Immunologically activated, better prognosis.','\n','Low RCSP: Extracellular matrix remodeling, poorer prognosis.'),theme = theme(plot.title = element_text(size = 20,hjust = 0.5,vjust = 0.5),plot.subtitle = element_text(size = 12,hjust = 1,vjust = 0.5)))
dev.off()
