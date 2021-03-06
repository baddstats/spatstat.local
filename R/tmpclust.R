#
# temporary table of additional information about cluster models.
# Under development..
# $Revision: 1.8 $ $Date: 2013/10/31 10:54:12 $

.Extra.ClusterModelInfoTable <-
  list(Thomas=list(
         # sibling probability
         psib = quote(1/(1 + 4 * pi * kappa * sigma2)),
         # transform to/from canonical parameters 
         par2theta = list(
           theta1 = quote(-log(4 * pi * kappa * sigma2)),
           theta2 = quote(-log(4 * sigma2))
           ),
         theta2par=list(
           kappa  = quote(exp(theta2-theta1)/pi),
           sigma2 = quote(exp(-theta2)/4)
           ),
         # pair correlation function: parallelised
         pcf= function(par,rvals, ...){
           n <- length(rvals)
           if(!is.matrix(par)) {
             kappa <- rep(par[1], n)
             sigma2 <- rep(par[2], n)
           } else {
             kappa <- par[,1]
             sigma2 <- par[,2]
           }
           ifelse(kappa > 0 & sigma2 > 0,
                  1 + exp(-rvals^2/(4 * sigma2))/(4 * pi * kappa * sigma2),
                  Inf)
         },
         # pair correlation function using transformed coordinates
         pcftheta= function(theta,rvals, ...){
           1 + exp(theta[1] - exp(theta[2]) * rvals^2)
         },
         # d/d(theta) log(pcf) : parallelised
         DlogpcfDtheta = function (theta, rvals, ...) {
           if(!is.matrix(theta)) theta <- matrix(theta, nrow=1)
           if(nrow(theta) != length(rvals) && nrow(theta) != 1)
               stop("Incompatible dimensions of theta and rvals")
           theta1 <- theta[,1]
           theta2 <- theta[,2]
           rsqterm <- (rvals^2) * exp(theta2)
           expoterm <- exp(theta1 - rsqterm)
           grad1 <- expoterm/(1 + expoterm)
           grad2 <- -rsqterm * grad1
           return(cbind(grad1, grad2))
         },
         # d^2/d(theta)^2 log(pcf) : parallelised
         D2logpcfDtheta2 = function(theta, rvals, ...) {
           if(!is.matrix(theta)) theta <- matrix(theta, nrow=1)
           if(nrow(theta) != length(rvals) && nrow(theta) != 1)
               stop("Incompatible dimensions of theta and rvals")
           theta1 <- theta[,1]
           theta2 <- theta[,2]
           rsqterm <- (rvals^2) * exp(theta2)
           expoterm <- exp(theta1 - rsqterm)
           pcfval <- 1 + expoterm
           grad1 <- expoterm/pcfval
           hess11 <- grad1 - grad1^2
           .hessian <- array(0, c(length(rvals), 2L, 2L),
                             list(NULL, 
                                  c("theta1", "theta2"),
                                  c("theta1", "theta2")))
           .hessian[, "theta1", "theta1"] <- hess11
           .hessian[, "theta1", "theta2"] <- 
             .hessian[, "theta2", "theta1"] <- - rsqterm * hess11
           .hessian[, "theta2", "theta2"] <-
             - rsqterm * (grad1 - rsqterm * hess11)
           return(.hessian)
         }
         ),
       MatClust = list(
         psib = quote(1/(1 + pi * kappa * R^2))
         ),
       Cauchy = list(
         psib = quote(1/(1 + 2 * pi * kappa * eta2))
         ),
       VarGamma = list(
         psib = quote(1/(1 + 4 * pi * nu.pcf * kappa * eta^2))
         ),
       # no entry for LGCP.
       # 
       # ,,,,,,,,,,,,,,,,, older stuff ,,,,,,,,,,,,,,,,,,,,,,,,,
       ThomasRecent=list(
         # sibling probability
         psib = quote(1/(1 + 4 * pi * kappa * sigma2)),
         # transform to/from canonical parameters 
         par2theta = list(
           theta1 = quote(log(pi * kappa)),
           theta2 = quote(log(4 * sigma2))
           ),
         theta2par=list(
           kappa  = quote(exp(theta1)/pi),
           sigma2 = quote(exp(theta2)/4)
           ),
         # d/d(theta) log(pcf) 
         DlogpcfDtheta = function (theta, rvals, ...) {
           theta1 <- theta[1]
           theta2 <- theta[2]
           rsq <- rvals^2
           rsqterm <- rsq * exp(-theta2)
           expoterm <- exp(-theta1 - theta2 - rsqterm)
           pcfval <- 1 + expoterm
           grad1 <- -expoterm/pcfval
           grad2 <- grad1 * (1 - rsqterm)
           return(cbind(grad1, grad2))
         },
         # d^2/d(theta)^2 log(pcf) 
         D2logpcfDtheta2 = function(theta, rvals, ...) {
           theta1 <- theta[1]
           theta2 <- theta[2]
           rsq <- rvals^2
           rsqterm <- rsq * exp(-theta2)
           expoterm <- exp(-theta1 - rsqterm - theta2)
           pcfval <- 1 + expoterm
           .expr10 <- expoterm/pcfval
           .expr13 <- pcfval^2
           .expr16 <- rsqterm - 1
           .expr17 <- expoterm * .expr16
           .expr18 <- .expr17/pcfval
           .hessian <- array(0, c(length(rvals), 2L, 2L),
                             list(NULL, 
                                  c("theta1", "theta2"), c("theta1", "theta2")))
           .hessian[, "theta1", "theta1"] <-
             .expr10 - expoterm * expoterm/.expr13
           .hessian[, "theta1", "theta2"] <-
             .hessian[, "theta2", "theta1"] <-
               -(.expr18 - expoterm * .expr17/.expr13)
           .hessian[, "theta2", "theta2"] <-
             (.expr17 * .expr16 - expoterm * rsqterm)/pcfval -
               .expr17 * .expr17/.expr13
           return(.hessian)
         }
         ),
       ThomasOld=list(
         # transform to/from canonical parameters 
         par2theta = list(
           theta1 = quote(1/(4 * sigma2)),
           theta2 = quote(log(4 * pi * kappa * sigma2))
           ),
         theta2par=list(
           kappa  = quote(theta1 * exp(theta2)/pi),
           sigma2 = quote(1/(4 * theta1))
           ),
         # d/d(theta) log(pcf) 
         DlogpcfDtheta = function (theta, rvals, ...) {
           theta1 <- theta[1]
           theta2 <- theta[2]
           rsq <- rvals^2
           expoterm <- exp(-rsq * theta1 - theta2)
           pcfval <- 1 + expoterm
           grad2 <- -expoterm/pcfval
           grad1 <- rsq * grad2
           return(cbind(grad1, grad2))
         },
         # d^2/d(theta)^2 log(pcf) 
         D2logpcfDtheta2 = function(theta, rvals, ...) {
           theta1 <- theta[1]
           theta2 <- theta[2]
           rsq <- rvals^2
           expoterm <- exp(-theta1 * rsq - theta2)
           commonbit <- expoterm/(1 + expoterm)^2
           .hessian <- array(0, c(length(rsq), 2L, 2L),
                   list(NULL, c("theta1", "theta2"), c("theta1", "theta2")))
           .hessian[, "theta1", "theta1"] <- rsq^2 * commonbit
           .hessian[, "theta1", "theta2"] <-
             .hessian[, "theta2", "theta1"] <- rsq * commonbit
           .hessian[, "theta2", "theta2"] <- commonbit
           return(.hessian)
         },
         # d/d(par) log(pcf) 
         Dlogpcf = function (par, rvals, ...) {
           if(any(par <= 0))
             return(rep.int(NA_real_, length(rvals)))
           kap <- par[1]
           sig2 <- par[2]
           rsq <- rvals^2
           fpks <- 4 * pi * kap * sig2
           expoterm <- exp(-rsq/(4 * sig2))
           pcfval <- 1 + expoterm/fpks
           gradkap <- -expoterm * (4 * pi * sig2)/(pcfval * fpks^2)
           gradsig2 <- (expoterm/pcfval) * (rsq/(4 * sig2^2) - 1/sig2)/fpks
           return(cbind(gradkap, gradsig2))
         },
         # d^2/d(par)^2 log(pcf) 
         D2logpcf = function (par, rvals, ...) {
           if(any(par <= 0))
             return(rep.int(NA_real_, length(rvals)))
           kap <- par[1]
           sig2 <- par[2]
           rsq <- rvals^2
           .expr2 <- 4 * sig2
           .expr4 <- exp(-rsq/.expr2)
           .expr5 <- 4 * pi
           .expr6 <- .expr5 * kap
           .expr7 <- .expr6 * sig2
           .expr9 <- 1 + .expr4/.expr7
           .expr11 <- .expr5 * sig2
           .expr12 <- .expr4 * .expr11
           .expr13 <- .expr7^2
           .expr14 <- .expr12/.expr13
           .expr20 <- .expr13^2
           .expr24 <- .expr9^2
           .expr27 <- rsq * 4
           .expr28 <- .expr2^2
           .expr29 <- .expr27/.expr28
           .expr30 <- .expr4 * .expr29
           .expr36 <- 2 * (.expr6 * .expr7)
           .expr42 <- .expr4 * .expr6
           .expr44 <- .expr30/.expr7 - .expr42/.expr13
           .expr60 <- .expr30 * .expr6/.expr13
           .hessian <- array(0,
                             c(length(rvals), 2L, 2L),
                             list(NULL, c("kap", "sig2"), c("kap", "sig2")))
           .hessian[, "kap", "kap"] <-
             .expr12 * (2 * .expr11 * .expr7)/.expr20/.expr9 - 
               .expr14 * .expr14/.expr24
           .hessian[, "kap", "sig2"] <-
             .hessian[, "sig2", "kap"] <-
               -(((.expr30 * .expr11 + .expr4 * .expr5)/.expr13 -
                  .expr12 * .expr36/.expr20)/.expr9 - 
                 .expr14 * .expr44/.expr24)
           .hessian[, "sig2", "sig2"] <-
             ((.expr30 * .expr29 -
               .expr4 * (.expr27 * (2 * (4 * .expr2))/.expr28^2))/.expr7 -
              .expr60 - (.expr60 - .expr42 * .expr36/.expr20))/.expr9 -
                .expr44 * .expr44/.expr24
           return(.hessian)
         }
         )
       )

extraClusterModelInfo <- function(name, warn=FALSE) {
  if(!is.character(name) || length(name) != 1)
    stop("Argument must be a single character string", call.=FALSE)
  nama2 <- names(.Extra.ClusterModelInfoTable)
  if(!(name %in% nama2)) {
    if(warn) warning(paste(sQuote(name), "is not recognised;",
                           "valid names are", commasep(sQuote(nama2))),
                     call.=FALSE)
    return(NULL)
  }
  out <- .Extra.ClusterModelInfoTable[[name]]
  return(out)
}

