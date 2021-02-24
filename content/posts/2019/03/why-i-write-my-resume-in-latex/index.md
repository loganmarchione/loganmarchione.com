---
title: "Why I write my resume in LaTeX"
date: "2019-03-01"
author: "Logan Marchione"
categories: 
  - "oc"
cover:
    image: "/assets/featured/featured_latex.svg"
    alt: "featured image"
    relative: false
---

# TL;DR

[Skip to the bottom](#advantages-of-a-latex-resume).

# Introduction

I receive a lot of email questions about [my resume](https://loganmarchione.com/resume/), specifically asking why I use LaTeX, and also asking for the source (which is at the very bottom). I thought I'd take a few minutes to discuss why I use LaTeX.

For the past 10 years, I've been writing my resume in Microsoft Word. Over time, it had become a burden to update. More often than not, I ended up fighting with the formatting, instead of focusing on the content. The slightest change to a column, graphic, or font would completely alter the formatting of the entire document. With this frustration in mind, I set out to find a new way to write my resume.

I first switched to LibreOffice Writer, but that didn't solve my formatting problem (although, I was happy to dump Word). I then looked into plain text, then Markdown, and finally HTML/CSS. However, each solution had its own advantages and disadvantages (shown below).

{{< procon/latex >}}

However, after searching Reddit, HackerNews, and StackExchange, I kept seeing LaTeX being recommended, so I decided to give it a shot.

## Disclaimer

Before I begin, I wanted to say a few things, because someone will call me out if I don't:

- I'm not a writer (obviously) and I don't write for a living (luckily for me).
- I'm not a LaTeX expert and I don't claim to be (talk to the folks at [TeX.SE](https://tex.stackexchange.com/)).
- I've only been using LaTeX for my resume for about a year.
- I don't write scientific papers or large documents using LaTeX.
- I'm not a typography nerd. Yes, [Computer Modern](https://en.wikipedia.org/wiki/Computer_Modern) is beautiful. Yes, LaTeX documents look great. That's not why I use LaTeX.

## A (very) brief history of TeX and LaTeX

### TeX

To understand LaTeX (pronounced like _lay-tek_), we first need to understand its predecessor, TeX (pronounced like _tek_). TeX was a [typesetting system](https://en.wikipedia.org/wiki/Typesetting) created by Donald Knuth in 1978 after he decided a book he was publishing looked awful (typographically), and he was determined to solve the problem himself. He created TeX with two goals in mind:

1. Allow anyone to create beautiful, high-quality books
2. Given an input, create the same output on any computer running TeX

TeX was a huge success, due to a number of reasons:

1. TeX was beautiful, mostly due to Knuth's attention to typographic detail (e.g., font styles, spacing, kerning, ligatures, etc...).
2. TeX had its own programming language, which meant users could write small macros (i.e., custom commands) to speed up their workflow.
3. TeX was open source, which also meant it was free.
4. TeX was portable, which meant it would run on almost any system and still produce the same output.

Knuth was more focused on stability and backwards compatibility than new features, and TeX was declared feature-complete in 1989 with version 3.0, with only minor bug fixes being applied since then (you can still download and use TeX today).

The main issue with TeX was that it focused mainly on the _format_ of documents, which was great if you knew the TeX language really well. However, it was difficult for writers to get it working correctly, which made focusing on _content_ difficult.

### LaTeX

To solve this, Leslie Lamport created LaTeX in 1983. LaTeX is essentially a collection of helpful TeX macros that Lamport created himself. When you use LaTeX commands, you're really just running a series of TeX commands. Because of these easy to use commands, LaTeX was simpler for writers to learn than TeX itself. In fact, the focus of LaTeX is more on the _separation_ of format and content (whereas TeX focused on the format itself). In a way, you can think of a LaTeX document like HTML and CSS. One file holds the content, while the other file holds the formatting for that content.

Because LaTeX was even easier to use than TeX, its popularity soared. It gained a huge following in academia, and is still mainly used for writing books and scientific papers. It also excels in writing tasks that require mathematical expressions or non-Latin scripts, such as Chinese or Sanskrit.

For example, below is piece of LaTeX code (taken from [Overleaf](https://www.overleaf.com/learn/latex/Learn_LaTeX_in_30_minutes#Adding_math_to_LaTeX)) with multiple mathematical expressions.

```
Subscripts in math mode are written as $a_b$ and superscripts are written as $a^b$. These can be combined an nested to write expressions such as

$$T^{i_1 i_2 \dots i_p}_{j_1 j_2 \dots j_q} = T(x^{i_1},\dots,x^{i_p},e_{j_1},\dots,e_{j_q})$$

We write integrals using $\int$ and fractions using $\frac{a}{b}$. Limits are placed on integrals using superscripts and subscripts:

$$\int_0^1 \frac{1}{e^x} = \frac{e-1}{e}$$

Lower case Greek letters are written as $\omega$ $\delta$ etc. while upper case Greek letters are written as $\Omega$ $\Delta$.

Mathematical operators are prefixed with a backslash as $\sin(\beta)$, $\cos(\alpha)$, $\log(x)$ etc.
```

Below is the same piece of code (taken from [Overleaf](https://www.overleaf.com/learn/latex/Learn_LaTeX_in_30_minutes#Adding_math_to_LaTeX)), but formatted via LaTeX. As I mentioned, one of the advantages of LaTeX is that the piece of code above will produce this exact output on any system running LaTeX.

{{< img src="20190228_002.png" alt="latex example screenshot" >}}

As if that wasn't enough, LaTeX also has the ability to load custom packages to add features/functionality. These packages include typical typesetting features, like:

- Adding custom fonts
- Customizing links
- Adding tables
- Adding image annotations
- Creating a table of contents

However, some fun packages that have absolutely nothing to do with typesetting include:

- Playing [Reversi](https://ctan.org/tex-archive/macros/plain/contrib/reverxii)
- Creating [sheet music](https://www.ctan.org/pkg/musixtex)
- Putting [coffee stains](http://hanno-rein.de/archives/349) on your documents
- Playing [sudoku](https://ctan.org/pkg/sudokubundle)
- Creating [knitting](https://www.ctan.org/pkg/knitting) patterns

# Advantages of a LaTeX resume

Now, onto the reason I'm writing this post. These are, in my opinion, the biggest advantages of using LaTeX to write your resume (in order).

## Less formatting, more content

This is the entire reason I moved away from Word. I wrote a template (called a _class_ in LaTeX) one time. Now, I know exactly how each piece of my resume will behave, because I'm using a template that is predictable.

## Modularity

Think of LaTeX as a programming language in that you write code, compile it, then execute it. When you write in LaTeX, you first write your plain text using any editor, let LaTeX compile the text, then output it to the screen or a file. My resume is modular because I can simply comment in/out a specific section, recompile, and I have a new resume that is tailored for a specific position.

## Version control (Git)

The source of a LaTeX resume is one or two text files which are easily tracked with Git. If you want to go back in time to see a specific thing, or simply undo something, having version control will help you.

## Complex formatting

Have you seen some of the formatting LaTeX can offer for mathematical expressions or non-Latin scripts? It's beautiful and consistent. Imagine trying to illustrate a quadratic equation in Microsoft Word.

## Packages

There are literally thousands of packages available for LaTeX. In addition, there are many pre-created resume classes to choose from (some great options include [Awesome CV](https://github.com/posquit0/Awesome-CV), [Fancy CV](https://www.sharelatex.com/templates/cv-or-resume/fancy-cv), [moderncv](https://ctan.org/pkg/moderncv), or [any of these](http://rpi.edu/dept/arc/training/latex/resumes/)).

## Stability

LaTex is stable. LaTeX (written in the 80's) still runs on top of the original TeX (written in the 70's). How many times will Microsoft Word go through new file formats in the next 20 or 30 years? Will you be able to open the Word document you wrote in 2019 on Word 2050?

## Output options

You don't want a recruiter editing your Word document, so you can output your resume to PDF. This also guarantees it will look great when printed (since you won't be worrying about custom fonts). PDF not enough? Need HTML? Need plain text? Need Markdown? Need Word? Need almost any other text format? Check out [Pandoc](https://pandoc.org/).

## Open source

I love things that are open source. I love things that are free. LaTeX is both.

## Typography

Like I mentioned, I'm not a typography nerd. However, you have to admit, you can tell a LaTeX document when you see one, and they are always beautiful and professional. I've never looked at something and said "Was this written in Microsoft Word?!".

# Disadvantages of a LaTeX resume

These are, in my opinion, the biggest disadvantages of using LaTeX to write your resume (in order).

## Learning curve

I'm going to admit, I had a hard time getting my class setup and working just right. All things equal, I could create the same resume in Word in a quarter of the time. In addition, finding the correct packages to get the formatting right was also difficult at first. And, don't get me started on the syntax, it was not easy to master.

## Lack of collaboration

If you want to get advice on your resume, you can't exactly send a .tex file to your friend to edit. Chances are, you'll need to output a PDF, which your friend will have to take notes on using a separate program. With Word, your friend could put comments directly into the .docx file and send it back to you.

## Install footprint

LaTeX itself takes up a lot of space, and once you start downloading packages, it adds up quickly. In addition, if you're using a GUI to edit your files, you need to account for that. Don't be surprised if a full installation takes up 2GB.

# Source files

## resume.tex

```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Identification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\documentclass{resume}
\geometry{letterpaper,portrait,margin=0.75in}
\begin{document}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Contact info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ContactName
{First Last}                              % first and last name

%\ContactInfoPhysical
%{123 Main Street}                         % house and street
%{City, State  ZIP}                        % city, state, zip
%{USA}                                     % country

\ContactInfoDigital
  {tel:+019876543210}                      % phone URL (with int'l code)
  {987-654-3210}                           % phone display text
  {mailto:email@domain.com}                % email URL
  {email@domain.com}                       % email display text
  {https://domain.com}                     % web URL
  {domain.com}                             % web display text

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Work experience
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{{\faBriefcase} Experience}
\PlaceAndLocation{Job Name}{City, State} \\
\TitleAndYears{Title}{MM YYYY - MM YYYY} \\
Duties \\
\begin{itemize}
  \item Thing 1.
  \item Thing 2.
  \item Thing 3.
\end{itemize}
Accomplishments \\
\begin{itemize}
  \item Thing 1.
  \item Thing 2.
  \item Thing 3.
\end{itemize}
\TitleAndYears{Title}{MM YYYY - MM YYYY} \\
\TitleAndYears{Title}{MM YYYY - MM YYYY} \\

\bigskip
\PlaceAndLocation{Job Name}{City, State} \\
\TitleAndYears{Title}{MM YYYY - MM YYYY} \\
\TitleAndYears{Title}{MM YYYY - MM YYYY} \\

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Education
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{{\faGraduationCap} Education}
\PlaceAndLocation{Job Name}{City, State} \\
\TitleAndYears{Major}{MM YYYY - MM YYYY} \\
\TitleAndYears{Minor}{GPA: 0.00/4.00} \\
%Accomplishments \\
\begin{itemize}
  \item Thing 1.
  \item Thing 2.
  \item Thing 3.
\end{itemize}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Skills
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{{\faCheck} Skills}
Put some text here.
\begin{itemize}
  \item Thing 1.
  \item Thing 2.
  \item Thing 3.
\end{itemize}

\end{document}
```

## resume.cls

```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Introduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This class (resume.cls) is to define the layout/structure of the template (resume.tex)
% All content should go in the template file (resume.tex), not this file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                OS Packages (Arch Linux)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arch packages
% sudo pacman -S texmaker texlive-most

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Identification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ProvidesClass{resume}
\NeedsTeXFormat{LaTeX2e}
\LoadClass{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\nofiles                                   % Don't create .aux files
\pagestyle{empty}                          % Don't use page numbers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{geometry}                  % To change page size/orientation/margins
\RequirePackage{fontawesome5}              % To use FontAwesome5
\RequirePackage[document]{ragged2e}        % To left-align everything (using [document])
\RequirePackage{enumitem}                  % To change spacing between lists 
  \setlist[itemize]{noitemsep,topsep=0pt}
\RequirePackage{titlesec}                  % To format the title
\RequirePackage{tabto}                     % To align text to a specific point
  \newcommand*{\rightsidetab}{.7\linewidth}% Set the tab on the right side
\RequirePackage{color}                     % To define specific colors
  \definecolor{darkblue}{RGB}{6,69,173}    % Custom color for URLs
\RequirePackage{hyperref}                  % To make clickable URLs and set PDF options       
  \hypersetup{
  colorlinks=true,
  linkcolor=darkblue,
  urlcolor=darkblue,
  pdftitle={Name},
  pdfauthor={Name}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contact info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ContactName}[1]{
  {\Huge{#1}}\\
}

\newcommand{\ContactInfoPhysical}[3]{
  {\faHome} {#1}, {#2} {#3}\\
}

\newcommand{\ContactInfoDigital}[6]{
  {\faPhone} \href{#1}{#2}  |  
  {\faEnvelope} \href{#3}{#4}  |  
  {\faGlobeAmericas} \href{#5}{#6}\\
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\titleformat{\section}
  {\Large}
  {}{0em}
  {}
  [\titlerule]

\newcommand*{\PlaceAndLocation}[2]{
  {\textbf{#1} \tabto{\rightsidetab}{\faMapMarker*} {#2}}
}

\newcommand*{\TitleAndYears}[2]{
  {\textit{#1} \tabto{\rightsidetab} {#2}}
}
```

Anyways, I really like LaTeX and I hope you check it out! Even if you don't stick with it, it's still something to learn!

\-Logan

# Comments

[Old comments from WordPress](/2019/03/why-i-write-my-resume-in-latex/comments.txt)