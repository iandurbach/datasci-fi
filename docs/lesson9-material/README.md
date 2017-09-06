# Data Science for Industry: R Packages and Shiny Apps

This directory contains companion resources for lesson 9 of [Data Science for Industry](https://github.com/iandurbach/datasci-fi). The lesson provides an introduction to the development of R packages and shiny apps.

Note that since the example `datasci` package here is located within a sudirectory and not the project root, you will need to configure RStudio's Build Tools as shown below:

> Build -> Configure Build Tools

Select Package in the Project build tools dropdown.

Update the package directory to `docs/lesson9-material/packages/datasci`

![](project_options.png)

You should then be able to use Build -> Load all / Build & Reload etc and other integrated package tooling within RStudio.

Another option is to just copy the package directory `packages/datasci` to a new location and create a new R project using the existing directory.
