# Latex

## Usage

Building the image:

```terminal
docker build -t latex .
```

Running the image with volume mounting to the desired workspace.

```terminal
docker run -it -v ~/Documents/latex:/workspace latex
```

Now you can compile the latex files inside the mounted volume via docker image shell.

```terminal
$ cd sample
$ pdflatex bib.tex && biber bib && pdflatex.tex
```
