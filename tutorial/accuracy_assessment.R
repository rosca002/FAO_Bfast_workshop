####Function to calculate the sample size#### 
calcSampleSize <- function(BFAST_raster,forest_mask,U,s){
  BFAST_raster[!is.na(BFAST_raster)] <- 1
  BFAST_raster[is.na(BFAST_raster)] <- 0
  BFAST_raster[is.na(forest_mask)] <- NA
  pixel_count <- table(BFAST_raster[])
  W <- pixel_count/sum(pixel_count)
  names(W) <- c("Forest","Deforestated")
  S <- sqrt(U*(1-U))
  n <- (sum(W*S)/s)^2
  c(n,n*W)
}
#### ####

####Function to select the sampling points####
extractRandomSamples <- function(BFAST_raster,forest_mask,sample_size,file_path,file_name){
  BFAST_raster[is.na(BFAST_raster)] <- 0
  BFAST_raster[is.na(forest_mask)] <- NA
  def_px <- which(BFAST_raster[]!=0)
  sample_def <- sample(def_px,round(sample_size[3]))
  sampling_raster <- BFAST_raster
  sampling_raster[!is.na(sampling_raster)] <- NA
  sampling_raster[sample_def] <- BFAST_raster[sample_def]
  forest_px<- which(BFAST_raster[]==0)
  sample_f <- sample(forest_px,round(sample_size[2]))
  sampling_raster[sample_f] <- 1
  Cell_no <- c(sample_def,sample_f)
  Coords <- xyFromCell(BFAST_raster,Cell_no,spatial=TRUE)
  Value <- c(BFAST_raster[sample_def],rep(1,round(sample_size[2])))
  my_data <- data.frame("Cell_number"= Cell_no, Value=Value, coords=Coords)
  my_points <- SpatialPointsDataFrame(Coords,my_data)
  writeOGR(my_points, dsn = path.expand(file_path), layer = file_name, driver = "ESRI Shapefile", overwrite=TRUE)
  #plot(sampling_raster,col=c("red","black"))
  writeRaster(sampling_raster,(paste0(file_path,"/",file_name,".tif")),overwrite=TRUE)
}
#### ####

####Function to extract the values of the sample points from the validation raster
extractValidationValues <- function(validation_map,bfm_sampling_raster,forest_mask){
  val_sample <- validation_map 
  val_sample [is.na(val_sample )] <- 0
  val_sample[is.na(forest_mask)] <- NA
  bfm_samples <- bfm_sampling_raster
  val_sample[is.na(bfm_samples)] <- NA
  val_sample
}


####Function to estimate the accuracy####
assessAcuracy <- function(bfm_sampling_raster,validation_sampling_raster){
  classification <- bfm_sampling_raster
  reference <- validation_sampling_raster
  classification[classification>1] <- 0
  classification[!is.na(classification)]
  reference[!is.na(reference)]
  conf_mat <- table(classification[],reference[])
  conf_mat_t <- cbind(conf_mat,rowSums(conf_mat))
  conf_mat_t <- rbind(conf_mat_t,colSums(conf_mat_t))
  conf_mat_ua <- cbind(conf_mat_t,c(diag(conf_mat)/rowSums(conf_mat),NA))
  conf_mat_pa <- rbind(conf_mat_ua,c(diag(conf_mat)/colSums(conf_mat),NA,sum(diag(conf_mat))/sum(conf_mat)))
  round(conf_mat_pa,2)
}
#### ####