# spatstat.local

This is an _extension_ of the `spatstat` package. 

It fits point process models to point pattern data by local composite likelihood (aka geographically weighted regression) as described in the forthcoming paper, A. Baddeley (2017) Local composite likelihood for spatial point processes, _Spatial Statistics_, in press.

This GitHub repository holds the *development version* of
`spatstat.utils`. The development version is newer than the *official release*
of `spatstat.utils` on CRAN. 

## Installing the official release

For the most recent **official release** of 
`spatstat.local`, see the [CRAN page](https://cran.r-project.org/web/packages/spatstat.local). To install it, just type

```R
install.packages('spatstat.local')
```

## Installing the development version

The easiest way to install the **development version** of `spatstat.local` 
from github is through the `remotes` package:

```R
require(remotes)
install_github('spatstat/spatstat.utils')
install_github('spatstat/spatstat')
install_github('baddstats/spatstat.local')
```

If you don't have `remotes` installed you should first run

```R
install.packages('remotes')
```


