# Latex

## Usage

```terminal
docker run -it  aksakalli/latex
```
Now the sample template inside your container can be compiled:

```terminal
cd sample
pdflatex bib && bibtex bib && pdflatex bib
```

This image comes with `vim` and `git` to easily clone & edit a latex document.

**Mounting the workspace folder**

It is easy to use host machine tools such as *GUI text editors* by mounting the workspace volume to desired host folder (such as `~/Documents/latex`):

```terminal
docker run -it -v ~/Documents/latex:/workspace aksakalli/latex
```
