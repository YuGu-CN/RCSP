#library(reticulate)
#use_condaenv("c://ProgramData/Anaconda3/python.exe")
#use_python("c://ProgramData/Anaconda3/python.exe")

dicom2nii = function(dicom_directory,output_folder){
  #RCSP_path = "D:/R-4.3.1/library/devtools"
  RCSP_path = 'D:/RSCP'
  source_python(paste0(RCSP_path,"/param/dicom2nii.py"))

  dicomtonii(dicom_directory = dicom_directory,
             output_folder = output_folder,
             RCSP_param = paste0(RCSP_path,'/param'))
}

