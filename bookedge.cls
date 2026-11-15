%% ============================================================
%% bookedge.cls —— 「书边索引」中文书籍模板
%% ------------------------------------------------------------
%% 特点：
%%   1. 每章对应一种专属色，书口（外缘）有整列「拇指索引」色块，
%%      当前章为实色、其余章为浅色底纹，翻口即可定位章节（字典式导航）；
%%   2. 章首页顶部有「导航尺」缩略图，同色系呼应；
%%   3. 目录带彩色章节标签；页眉页码为色块徽章；
%%   4. 内置 词条/要点/示例 三种图文框，自动取当前章色。
%%
%% 用法（在正文文件中）：
%%   \documentclass{bookedge}
%%   \title{...} \author{...} \epigraph{副书名} \publishinfo{出版信息}
%%   \begin{document}
%%   \maketitle            % 封面（书口彩条自动绘制）
%%   ...前言、使用说明...
%%   \bookedgetabson       % 从下一页开始启用书边索引（一般放在目录之前）
%%   \tableofcontents
%%   \mainmatter
%%   \part{...}（可选）
%%   \chapter{...}
%%   \end{document}
%% 可选类选项：openright（默认，章与部一律起于正面/奇数页，符合印刷书规范）
%%             openany（章可从任意页开始，适合纯电子稿、屏幕阅读）
%%             gray    （灰度版：章节改用 10 级灰阶区分，供黑白打印）
%% 手工指定总章数（一般无需，两遍编译自动获取）：\bookedgetotal{12}
%% ============================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bookedge}[2026/11/15 v1.0 Thumb-index book template]

% ---------------- 选项 ----------------
\newif\ifbookedge@openright
\newif\ifbookedge@gray
\DeclareOption{openright}{\bookedge@openrighttrue}
\DeclareOption{openany}{\bookedge@openrightfalse}
\DeclareOption{gray}{\bookedge@graytrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ExecuteOptions{openright}
\ProcessOptions\relax

\ifbookedge@openright
  \LoadClass[zihao=5,fontset=none,openright]{ctexbook}
\else
  \LoadClass[zihao=5,fontset=none,openany]{ctexbook}
\fi

% ---------------- 宏包 ----------------
\RequirePackage{geometry}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{eso-pic}
\RequirePackage{tikz}
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins, breakable}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}

% ---------------- 版面 ----------------
% 170 x 240 mm（常用书籍开本），外缘留宽白边给索引色块
\geometry{
  paperwidth=170mm, paperheight=240mm,
  inner=21mm, outer=31mm,
  top=24mm, bottom=28mm,
  headheight=16pt, headsep=6mm, footskip=10mm
}
\linespread{1.42}
\setlength{\emergencystretch}{2em}

% ---------------- 字体 ----------------
\setmainfont{TeX Gyre Termes}
\setsansfont{TeX Gyre Heros}
% 中文正文：Fandol 宋体（含真粗体）；标题：思源黑体（Noto Sans SC）
\setCJKmainfont{FandolSong}[BoldFont=FandolSong-Bold]
\setCJKsansfont[
  Path=C:/Windows/Fonts/,
  UprightFont={Noto Sans SC (TrueType).otf},
  BoldFont={Noto Sans SC Bold (TrueType).otf}
]{NotoSansSC}
\setCJKmonofont[
  Path=C:/Windows/Fonts/,
  UprightFont={Noto Sans SC (TrueType).otf},
  BoldFont={Noto Sans SC Bold (TrueType).otf}
]{NotoSansSC-Mono}
\newCJKfontfamily\kaishu{FandolKai}[BoldFont=FandolKai-Regular]

% ---------------- 色板（10 色，低饱和、白字可读） ----------------
% 灰度模式：改用 10 级灰阶承载章节区分，第 1 章最浅、第 10 章最深，
% 相邻档约 8%，黑白激光打印件上仍可分辨；当前章的索引块统一改用
% 纯黑（灰度下最醒目的定位标记），其余章保持各自灰阶。
% 正文小字不按章取色，统一用深灰（见 \bookedge@ink），避免浅灰小字发虚。
\ifbookedge@gray
  \definecolor{beC1}{gray}{0.82}   % 灰阶 1（最浅）
  \definecolor{beC2}{gray}{0.74}
  \definecolor{beC3}{gray}{0.66}
  \definecolor{beC4}{gray}{0.58}
  \definecolor{beC5}{gray}{0.50}
  \definecolor{beC6}{gray}{0.42}
  \definecolor{beC7}{gray}{0.34}
  \definecolor{beC8}{gray}{0.26}
  \definecolor{beC9}{gray}{0.18}
  \definecolor{beC10}{gray}{0.10}  % 灰阶 10（最深）
\else
  \definecolor{beC1}{HTML}{A6433A}   % 朱砂
  \definecolor{beC2}{HTML}{B4602A}   % 赭橙
  \definecolor{beC3}{HTML}{9A7A1E}   % 金棕
  \definecolor{beC4}{HTML}{55803C}   % 苔绿
  \definecolor{beC5}{HTML}{2E7D74}   % 松青
  \definecolor{beC6}{HTML}{31608E}   % 靛蓝
  \definecolor{beC7}{HTML}{5D5592}   % 紫藤
  \definecolor{beC8}{HTML}{92516E}   % 玫紫
  \definecolor{beC9}{HTML}{4F6B77}   % 蓝灰
  \definecolor{beC10}{HTML}{74553C}  % 棕褐
\fi

% 30 章以内每章固定取色（10 色循环 3 轮），保证 \edef 可展开
\colorlet{beC11}{beC1}\colorlet{beC12}{beC2}\colorlet{beC13}{beC3}%
\colorlet{beC14}{beC4}\colorlet{beC15}{beC5}\colorlet{beC16}{beC6}%
\colorlet{beC17}{beC7}\colorlet{beC18}{beC8}\colorlet{beC19}{beC9}%
\colorlet{beC20}{beC10}\colorlet{beC21}{beC1}\colorlet{beC22}{beC2}%
\colorlet{beC23}{beC3}\colorlet{beC24}{beC4}\colorlet{beC25}{beC5}%
\colorlet{beC26}{beC6}\colorlet{beC27}{beC7}\colorlet{beC28}{beC8}%
\colorlet{beC29}{beC9}\colorlet{beC30}{beC10}
\newcommand\bookedge@colorname[1]{%
  \ifnum\numexpr#1\relax>30 beC30\else beC\the\numexpr#1\relax\fi}
% 两位数字补零
\newcommand\bookedge@padnum[1]{\ifnum#1<10 0\fi\the\numexpr#1\relax}

% ---------------- 灰度 / 彩色 统一取色接口 ----------------
% \bookedge@oncolor{i}：第 i 章灰阶上该用的文字色（浅灰配深字、深灰配白字）；
% 可完全展开，供 TikZ 选项与 \edef 使用。
\def\bookedge@oncolor#1{%
  \ifbookedge@gray
    \ifnum#1>20 \bookedge@oncolor@a{\numexpr#1-20}%
    \else\ifnum#1>10 \bookedge@oncolor@a{\numexpr#1-10}%
    \else\bookedge@oncolor@a{#1}%
    \fi\fi
  \else white\fi}
\def\bookedge@oncolor@a#1{\ifnum#1>5 white\else black!88\fi}
% 标题与正文强调色：彩色版取章色；灰度版统一深灰，保证小字够黑
\newcommand\bookedge@ink{\ifbookedge@gray black!82\else\bookedge@curcolname\fi}
% 部页：色带填充 / 整页淡底 / PART 文字
\newcommand\bookedge@partfill{\ifbookedge@gray black!82\else\bookedge@curcolname\fi}
\newcommand\bookedge@parttint{\ifbookedge@gray black!4\else\bookedge@curcolname!5\fi}
\newcommand\bookedge@partlabel{\ifbookedge@gray black!45\else\bookedge@curcolname!55\fi}
% 索引条：当前章（灰度版用纯黑定位）与非当前章（用本章灰阶区分）
\newcommand\bookedge@tabactfill{\ifbookedge@gray black\else\beCn\fi}
\newcommand\bookedge@tabfill{\ifbookedge@gray\beCn\else\beCn!12\fi}
\def\bookedge@tabink#1{\ifbookedge@gray\bookedge@oncolor{#1}\else\beCn!62\fi}
% 章首页导航尺
\newcommand\bookedge@ruleractfill{\ifbookedge@gray black\else\beCn\fi}
\newcommand\bookedge@rulerfill{\ifbookedge@gray\beCn\else\beCn!10\fi}
\def\bookedge@rulerink#1{\ifbookedge@gray\bookedge@oncolor{#1}\else\beCn!65\fi}
% 各层级标题编号：彩色版逐级淡化章色；灰度版逐级淡化深灰
\newcommand\bookedge@subink{\ifbookedge@gray black!72\else\bookedge@curcolname!75\fi}
\newcommand\bookedge@subsubink{\ifbookedge@gray black!60\else\bookedge@curcolname!60\fi}
% 词条框：底 / 框线 / 标题文字
\newcommand\bookedge@entrytint{\ifbookedge@gray black!3\else\bookedge@curcolname!5\fi}
\newcommand\bookedge@entryrule{\ifbookedge@gray black!50\else\bookedge@curcolname\fi}
\newcommand\bookedge@entrytitle{\ifbookedge@gray\bookedge@oncolor{\bookedge@curidx}\else white\fi}
% 示例框
\newcommand\bookedge@exaback{\ifbookedge@gray black!4\else beC5!4\fi}
\newcommand\bookedge@exarule{\ifbookedge@gray black!55\else beC5!85\fi}

% ---------------- 章节索引计数 ----------------
\newcounter{bookedge@chap}
\xdef\bookedge@curidx{0}          % 当前章序号（0 = 尚无章，如目录页）
\xdef\bookedge@curcolname{beC1}   % 当前章颜色名
\gdef\bookedge@total{0}           % 总章数（由 aux 自动获取，两遍编译后生效）
\xdef\bookedge@totalfixed{0}
\newcommand\bookedgetotal[1]{\gdef\bookedge@total{#1}\xdef\bookedge@totalfixed{1}}
\newcommand\bookedgetabssave[1]{\gdef\bookedge@total{#1}}
\AtEndDocument{%
  \immediate\write\@auxout{\string\bookedgetabssave{\the\value{bookedge@chap}}}}

% 每进入一个编号章（已过 \clearpage，时机安全）：更新索引与颜色
\pretocmd{\@chapter}{%
  \stepcounter{bookedge@chap}%
  \xdef\bookedge@curidx{\arabic{bookedge@chap}}%
  \xdef\bookedge@curcolname{\bookedge@colorname{\arabic{bookedge@chap}}}%
}{}{\ClassError{bookedge}{无法挂接章命令}{请勿与其它重定义 chapter 的宏包混用}}

% ---------------- 书边索引（thumb tabs） ----------------
\newif\ifbookedge@tabs     \bookedge@tabsfalse
\newif\ifbookedge@notabs   \bookedge@notabsfalse
\newcommand\bookedgetabson{\global\bookedge@tabstrue}

% 绝对页计数器：每次出货 +1，永不因 \pagenumbering 清零。
% 索引条与页眉的左右取向一律按它判断，保证与纸张正反面一致。
% 计数挂在 \@outputpage 入口（出货例程最早时机），早于页眉宏与
% eso-pic 背景钩子执行，保证两者取到一致的值。
\newcounter{bookedge@abs}
\pretocmd{\@outputpage}{\stepcounter{bookedge@abs}}{}{}%

\AddToShipoutPictureBG{\bookedge@tabs@shipout}
\def\bookedge@tabs@shipout{%
  \ifbookedge@notabs
    \global\bookedge@notabsfalse
  \else
    \ifbookedge@tabs\bookedge@tabs@draw\fi
  \fi}

\def\bookedge@tabs@draw{%
  \ifnum\bookedge@total>0
  \begin{tikzpicture}[remember picture, overlay, x=1pt, y=1pt]
    \pgfmathsetmacro\bePW{\paperwidth/1pt}
    \pgfmathsetmacro\bePH{\paperheight/1pt}
    \pgfmathsetmacro\beT{62}                 % 索引区顶部留白 (pt)
    \pgfmathsetmacro\beSlot{(\bePH-124)/\bookedge@total}
    \pgfmathsetmacro\beWact{29}              % 当前章色块宽 (pt)
    \pgfmathsetmacro\beWina{17}              % 其余章色块宽 (pt)
    \foreach \i in {1,...,\bookedge@total}{%
      % y 轴向上、原点在页面左下（eso-pic 背景层），故从顶部起算的
      % 第 \i 槽位需换算：顶部留白 beT 对应页高减去 beT。
      \pgfmathsetmacro\beYtwo{\bePH-\beT-(\i-1)*\beSlot}%
      \pgfmathsetmacro\beYone{\beYtwo-\beSlot+1.7}%
      \pgfmathsetmacro\beYmid{(\beYone+\beYtwo)/2}
      \edef\beCn{\bookedge@colorname{\i}}%
      \edef\beFillAct{\bookedge@tabactfill}%
      \edef\beFillIn{\bookedge@tabfill}%
      \edef\beTxtIn{\bookedge@tabink{\i}}%
      \ifnum\i=\bookedge@curidx\relax
        \ifodd\value{bookedge@abs}
          \fill[\beFillAct, rounded corners=2.2pt]
            ({\bePW-\beWact},{\beYone}) rectangle ({\bePW},{\beYtwo});
          \node[rotate=90] at ({\bePW-\beWact/2},{\beYmid})
            {\textcolor{white}{\sffamily\bfseries\fontsize{7.6}{7.6}\selectfont\bookedge@padnum{\i}}};
        \else
          \fill[\beFillAct, rounded corners=2.2pt]
            ({0},{\beYone}) rectangle ({\beWact},{\beYtwo});
          \node[rotate=90] at ({\beWact/2},{\beYmid})
            {\textcolor{white}{\sffamily\bfseries\fontsize{7.6}{7.6}\selectfont\bookedge@padnum{\i}}};
        \fi
      \else
        \ifodd\value{bookedge@abs}
          \fill[\beFillIn, rounded corners=2.2pt]
            ({\bePW-\beWina},{\beYone}) rectangle ({\bePW},{\beYtwo});
          \node[rotate=90] at ({\bePW-\beWina/2},{\beYmid})
            {\textcolor{\beTxtIn}{\sffamily\fontsize{6.2}{6.2}\selectfont\bookedge@padnum{\i}}};
        \else
          \fill[\beFillIn, rounded corners=2.2pt]
            ({0},{\beYone}) rectangle ({\beWina},{\beYtwo});
          \node[rotate=90] at ({\beWina/2},{\beYmid})
            {\textcolor{\beTxtIn}{\sffamily\fontsize{6.2}{6.2}\selectfont\bookedge@padnum{\i}}};
        \fi
      \fi
    }
  \end{tikzpicture}%
  \fi}

% ---------------- 页眉页脚 ----------------
\newcommand\bookedge@pagechip{%
  \edef\bookedge@chiptext{\bookedge@oncolor{\bookedge@curidx}}%
  \tikz[baseline=-0.9ex]{\node[fill=\bookedge@curcolname, text=\bookedge@chiptext,
    font=\sffamily\bfseries\footnotesize, inner xsep=4.5pt, inner ysep=2.6pt,
    rounded corners=1.2pt]{\thepage};}}

\newcommand\bookedge@booktitle{书名待定}   % 内部使用
% 用户接口：设置书名（用于页眉与 PDF 元信息）
\newcommand\bookedgetitle[1]{\gdef\bookedge@booktitle{#1}}
\newcommand\bookedge@runhead{}             % 页眉中的章名

\fancypagestyle{main}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  % 页码徽章永远在书口侧（正面右、反面左），章名/书名在内侧；
  % 奇偶一律按绝对页计数器判断，不受 \pagenumbering 重置影响。
  \fancyhead[LO,LE]{\ifodd\value{bookedge@abs}%
      \ifx\bookedge@runhead\empty\relax\else
        {\sffamily\footnotesize\color{black!55}\bookedge@runhead}\fi
    \else\bookedge@pagechip\fi}%
  \fancyhead[RO,RE]{\ifodd\value{bookedge@abs}%
      \bookedge@pagechip
    \else{\sffamily\footnotesize\color{black!55}\bookedge@booktitle}\fi}%
}
\fancypagestyle{bookedge@open}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \fancyfoot[RO,LE]{{\sffamily\footnotesize\color{black!45}\thepage}}%
}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \fancyfoot[C]{{\sffamily\footnotesize\color{black!45}\thepage}}%
}
\pagestyle{main}

\renewcommand\chaptermark[1]{\protected@xdef\bookedge@runhead{#1}}
\pretocmd{\@makeschapterhead}{\xdef\bookedge@runhead{}}{}{}

% ---------------- 章首页设计 ----------------
% 章首「导航尺」：全书各章色块缩略，当前章高亮
\newcommand\bookedge@navruler{%
  \ifnum\bookedge@total>0
  \begin{tikzpicture}[x=1mm, y=1mm]
    \foreach \i in {1,...,\bookedge@total}{%
      \edef\beCn{\bookedge@colorname{\i}}%
      \edef\beFillAct{\bookedge@ruleractfill}%
      \edef\beFillIn{\bookedge@rulerfill}%
      \edef\beTxtIn{\bookedge@rulerink{\i}}%
      \pgfmathsetmacro\bx{(\i-1)*7.6}%
      \ifnum\i=\bookedge@curidx\relax
        \node[anchor=south, fill=\beFillAct, text=white, minimum width=6.8mm,
          minimum height=5.2mm, inner sep=0pt,
          font=\sffamily\bfseries\fontsize{6.2}{6.2}\selectfont]
          at ({\bx+3.4},{0}) {\bookedge@padnum{\i}};
      \else
        \node[anchor=south, fill=\beFillIn, text=\beTxtIn, minimum width=6.8mm,
          minimum height=4mm, inner sep=0pt,
          font=\sffamily\fontsize{5.5}{5.5}\selectfont]
          at ({\bx+3.4},{0}) {\bookedge@padnum{\i}};
      \fi
    }
  \end{tikzpicture}%
  \fi}

\def\@makechapterhead#1{%
  \thispagestyle{bookedge@open}%
  {\parindent\z@ \raggedright \normalfont
    \bookedge@navruler\par\nobreak
    \vskip 15mm
    \ifnum\value{chapter}>0
      {\color{\bookedge@ink}%
        {\sffamily\bfseries\fontsize{50}{50}\selectfont
         \bookedge@padnum{\value{chapter}}}\par}%
      \vskip 2.5mm
      {\sffamily\fontsize{8.6}{11}\selectfont\color{black!40}%
        第\chinese{chapter}章\quad CHAPTER \bookedge@padnum{\value{chapter}}\par}%
    \fi
    \vskip 4.5mm
    {\sffamily\bfseries\fontsize{21.5}{27}\selectfont\color{black!88}#1\par}%
    \nobreak\vskip 6.5mm
    {\color{\bookedge@ink}%
      \rule{42mm}{2.6pt}\hspace{2.4mm}\rule{7mm}{2.6pt}\hspace{2.4mm}\rule{2.6pt}{2.6pt}}\par
    \vskip 13mm
  }%
}
\def\@makeschapterhead#1{%
  \thispagestyle{bookedge@open}%
  {\parindent\z@ \raggedright \normalfont
    \bookedge@navruler\par\nobreak
    \vskip 17mm
    {\sffamily\bfseries\fontsize{22}{28}\selectfont\color{black!88}#1\par}%
    \nobreak\vskip 6.5mm
    {\color{black!25}%
      \rule{42mm}{2.6pt}\hspace{2.4mm}\rule{7mm}{2.6pt}\hspace{2.4mm}\rule{2.6pt}{2.6pt}}\par
    \vskip 13mm
  }%
}

% ---------------- 部分（part）页 ----------------
\newcounter{bookedge@part}
% 部页跟随 openany/openright 设置，不强制另起正面
\ctexset{part/break = {\ifbookedge@openright\cleardoublepage\else\clearpage\fi}}
% frontmatter / mainmatter / backmatter 同样尊重 openany：openright 时才垫白
\renewcommand\frontmatter{%
  \ifbookedge@openright\cleardoublepage\else\clearpage\fi
  \@mainmatterfalse
  \pagenumbering{roman}}
\renewcommand\mainmatter{%
  \ifbookedge@openright\cleardoublepage\else\clearpage\fi
  \@mainmattertrue
  \pagenumbering{arabic}}
\renewcommand\backmatter{%
  \ifbookedge@openright\cleardoublepage\else\clearpage\fi
  \@mainmatterfalse
  \clearpage}
\renewcommand\@part[2][]{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{\thepart\hspace{1em}#2}%
  \else
    \addcontentsline{toc}{part}{#2}%
  \fi
  \stepcounter{bookedge@part}%
  \xdef\bookedge@curcolname{\bookedge@colorname{\arabic{bookedge@part}}}%
  \global\bookedge@notabstrue
  \thispagestyle{empty}%
  \xdef\bookedge@runhead{}%
  \tikz[remember picture, overlay]{
    \fill[\bookedge@parttint] (current page.south west) rectangle (current page.north east);
    \fill[\bookedge@partfill] ([yshift=-96mm]current page.north west) rectangle ([yshift=-110mm]current page.north east);
    \node[anchor=west] at ([yshift=-128mm, xshift=21mm]current page.north west)
      {\textcolor{\bookedge@partlabel}{\sffamily\fontsize{13}{16}\selectfont\bfseries
        PART \bookedge@padnum{\value{part}}\quad 第\chinese{part}部分}};
    \node[anchor=west] at ([yshift=-146mm, xshift=21mm]current page.north west)
      {\textcolor{black!88}{\sffamily\bfseries\fontsize{26}{32}\selectfont #2}};
  }%
  \vspace*{60mm}\par
  \@endpart}

% ---------------- 标题层级（经 ctexset，兼容 ctexbook） ----------------
\ctexset{
  section = {
    format = {\sffamily\bfseries\fontsize{13}{17}\selectfont\color{black!85}},
    name = {}, aftername = {\hspace{0.75em}},
    number = {\textcolor{\bookedge@ink}{\thesection}},
    beforeskip = {3.2ex plus 0.5ex minus 0.15ex}, afterskip = {1.4ex plus 0.2ex},
    afterindent = false,
  },
  subsection = {
    format = {\sffamily\bfseries\fontsize{11.5}{15}\selectfont\color{black!78}},
    name = {}, aftername = {\hspace{0.7em}},
    number = {\textcolor{\bookedge@subink}{\thesubsection}},
    beforeskip = {2.6ex plus 0.4ex minus 0.1ex}, afterskip = {1.1ex plus 0.2ex},
    afterindent = false,
  },
  subsubsection = {
    format = {\sffamily\fontsize{10.5}{14}\selectfont\color{black!80}},
    name = {}, aftername = {\hspace{0.7em}},
    number = {\textcolor{\bookedge@subsubink}{\thesubsubsection}},
    beforeskip = {2.2ex plus 0.3ex}, afterskip = {0.9ex},
    afterindent = false,
  },
}

% ---------------- 目录样式 ----------------
% 目录章编号改用阿拉伯数字（保证目录色签可靠取色）
\ctexset{chapter/tocline = {\protect\numberline{\thechapter}#2}}
\titlecontents{part}[0pt]
  {\addvspace{15pt}\sffamily\bfseries\fontsize{11.5}{14}\selectfont\color{black!82}}
  {\contentslabel{3.4em}}
  {}
  {\hfill\contentspage}
\titlecontents{chapter}[0mm]
  {\addvspace{11pt}\sffamily\bfseries\fontsize{11}{13}\selectfont\color{black!85}}
  {\bookedge@tocchip{\thecontentslabel}%
   \hspace{3.2mm}{\color{black!55}\thecontentslabel}\hspace{3.6mm}}
  {\hspace{0.4mm}}
  {\hfill\contentspage}
\titlecontents{section}[9mm]
  {\fontsize{9.3}{13}\selectfont\color{black!70}}
  {\textcolor{black!50}{\thecontentslabel}\hspace{2.2mm}}
  {}
  {\titlerule*[0.45pc]{.}\contentspage}
\titlecontents{subsection}[16mm]
  {\fontsize{8.8}{12}\selectfont\color{black!55}}
  {\thecontentslabel\hspace{2mm}}
  {}
  {\titlerule*[0.45pc]{.}\contentspage}

% 目录章条目左侧色签
\newcommand\bookedge@tocchip[1]{%
  \edef\bookedge@toctext{\bookedge@oncolor{#1}}%
  \tikz[baseline=-0.85ex]{\node[fill=\bookedge@colorname{#1}, text=\bookedge@toctext,
    font=\sffamily\bfseries\fontsize{6.6}{6.6}\selectfont,
    minimum width=5.6mm, minimum height=4.6mm, inner sep=0pt,
    rounded corners=1pt]{\bookedge@padnum{#1}};}}

% ---------------- 图文框 ----------------
\tcbset{
  beboxbase/.style={
    enhanced jigsaw, breakable, boxrule=0pt, leftrule=2.6pt,
    arc=1.8mm, left=4.6mm, right=4.2mm, top=5.4mm, bottom=3.4mm,
    fonttitle=\sffamily\bfseries\fontsize{9.6}{12}\selectfont,
    coltitle=white, attach boxed title to top left={yshift=-2.6mm, xshift=4.2mm},
    boxed title style={enhanced, boxrule=0pt, arc=1.2mm, left=2.8mm, right=2.8mm,
      top=1.5mm, bottom=1.5mm},
  }
}
% 词条（字典式条目：术语 + 外文对照 + 释义）
\newtcolorbox{entry}[3][]{beboxbase,
  colback=\bookedge@entrytint, colframe=\bookedge@entryrule,
  colbacktitle=\bookedge@curcolname, coltitle=\bookedge@entrytitle,
  title={#2\quad{\normalfont\sffamily\fontsize{7.8}{9}\selectfont #3}},
  #1}
% 要点
\newtcolorbox{notebox}[2][]{beboxbase,
  colback=black!3, colframe=black!62, colbacktitle=black!62,
  title={#2}, #1}
% 示例
\newtcolorbox{examplebox}[2][]{beboxbase,
  colback=\bookedge@exaback, colframe=\bookedge@exarule, colbacktitle=\bookedge@exarule,
  title={#2}, #1}

% ---------------- 列表 ----------------
\setlist[itemize,1]{label={\textcolor{\bookedge@ink}{\rule[0.06em]{1.7mm}{1.7mm}}},
  leftmargin=2em, itemsep=0.25ex, topsep=0.6ex}
\setlist[itemize,2]{label={\textcolor{\bookedge@subink}{\rule[0.06em]{1.3mm}{1.3mm}}},
  leftmargin=2em}
\setlist[enumerate,1]{leftmargin=2.4em, itemsep=0.25ex, topsep=0.6ex,
  font=\sffamily\bfseries\color{\bookedge@ink}}

% ---------------- 封面 ----------------
\newcommand\bookedge@maketitlepage{%
  \thispagestyle{empty}%
  \AddToShipoutPictureBG*{%
    \begin{tikzpicture}[remember picture, overlay, x=1pt, y=1pt]
      \pgfmathsetmacro\bePH{\paperheight/1pt}
      \pgfmathsetmacro\bePW{\paperwidth/1pt}
      \pgfmathsetmacro\beSlot{\bePH/10}
      \foreach \i in {1,...,10}{%
        \pgfmathsetmacro\byA{\bePH-(\i-1)*\beSlot}%
        \pgfmathsetmacro\byB{\bePH-\i*\beSlot+1.4}%
        \edef\beCn{\bookedge@colorname{\i}}%
        \fill[\beCn] ({\bePW-30},{\byB}) rectangle ({\bePW},{\byA-1.4});
      }
    \end{tikzpicture}}%
  \null
  \vspace*{34mm}%
  \noindent{\sffamily\fontsize{8.6}{11}\selectfont\color{black!45}\bookedge@booktitle\quad ・\quad 系列设计手册\par}%
  \vskip 9mm
  \noindent{\sffamily\bfseries\fontsize{33}{44}\selectfont\color{black!90}\@title\par}%
  \vskip 7mm
  \noindent{\sffamily\fontsize{12}{17}\selectfont\color{black!55}\@epigraph\par}%
  \vskip 22mm
  \noindent{\color{beC1}\rule{52mm}{3pt}\par}%
  \vskip 6mm
  \noindent{\sffamily\fontsize{10.5}{15}\selectfont\color{black!65}\@author\par}%
  \vfill
  \noindent{\sffamily\footnotesize\color{black!40}\@publishinfo\par}%
  \vspace*{16mm}%
  \clearpage}

% 用户接口
\newcommand\epigraph[1]{\gdef\@epigraph{#1}}
\newcommand\publishinfo[1]{\gdef\@publishinfo{#1}}
\gdef\@epigraph{}
\gdef\@publishinfo{}
\renewcommand\maketitle{\bookedge@maketitlepage}

% ---------------- 超链接 ----------------
\AtEndPreamble{\RequirePackage[colorlinks=true,
  linkcolor=black!62, urlcolor=beC6, citecolor=black!62]{hyperref}}

\endinput
