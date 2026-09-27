% author: Tz-Huan Huang [http://www.csie.ntu.edu.tw/~tzhuan]

% ----------------------------------------------------------------------------
% "THE CHOCOLATE-WARE LICENSE":
% Tz-Huan Huang wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a chocolate in return Tz-Huan Huang
% ----------------------------------------------------------------------------

% ----------------------------------------------------------------------------
% 本檔預設實作「國立政治大學碩士學位論文」格式。
% 換到其他學校時，請直接修改本檔，並對照 thesis-writing skill 的
% references/format-settings.md 逐項核對與修改。
% ----------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesisclass}[2013/04/23 Chinese thesis class, NCCU layout by default]

% Derived from book class
\DeclareRobustCommand{\@typeen}{Master}
\DeclareRobustCommand{\@typezh}{碩士學位}
\DeclareRobustCommand{\@classen}{Thesis}
\DeclareRobustCommand{\@classzh}{論文}
\DeclareOption{phd}{\gdef\@typeen{Doctoral}\gdef\@typezh{博士}\gdef\@classen{Dissertation}}
\DeclareOption{proposal}{\gdef\@typeen{Proposal for Doctoral}\gdef\@typezh{博士論文計畫提案書}\gdef\@classen{Dissertation}\gdef\@classzh{}}

\def\@doubleline{1.9}
\def\@onehalfline{1.62}
\DeclareRobustCommand{\@setspacing}{\setstretch{\@doubleline}}
\newif\ifzh
\zhfalse
\DeclareOption{zh}{\gdef\@setspacing{\setstretch{\@onehalfline}}\zhtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[a4paper,12pt,oneside]{book}

% Required packages
% Thesis page margins (set to 2.54cm on all sides unless your department specifies otherwise)
\RequirePackage[top=1cm,left=2.54cm,bottom=1cm,right=2.54cm, includeheadfoot]{geometry}

\RequirePackage{xeCJK}
\RequirePackage{setspace}
\RequirePackage{titlesec}
\RequirePackage{indentfirst}
\RequirePackage{tocloft} % for centering title
\RequirePackage[notbib]{tocbibind} % include ToC/LoF/LoT into ToC
\RequirePackage{titlesec} % for formatting title
\RequirePackage{titletoc} % for formatting toc
\RequirePackage{etoolbox} % for patchcmd
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}
\RequirePackage{caption}
\captionsetup{labelsep=space}

% Unified reference macros
\newcommand{\figref}[1]{圖~\ref{#1}}
\newcommand{\figrefb}[1]{[圖~\ref{#1}]}

% Declarations
\DeclareRobustCommand{\university}[2]{\gdef\@universityen{#1}\gdef\@universityzh{#2}}
\DeclareRobustCommand{\college}[2]{\gdef\@collegeen{#1}\gdef\@collegezh{#2}}
\DeclareRobustCommand{\institute}[2]{\gdef\@instituteen{#1}\gdef\@institutezh{#2}}
\DeclareRobustCommand{\title}[2]{\gdef\@titleen{#1}\gdef\@titlezh{#2}}
\DeclareRobustCommand{\author}[2]{\gdef\@authoren{#1}\gdef\@authorzh{#2}}
\DeclareRobustCommand{\studentid}[1]{\gdef\@studentid{#1}}
\DeclareRobustCommand{\advisor}[2]{\gdef\@advisoren{#1}\gdef\@advisorzh{#2}}
\DeclareRobustCommand{\defenseyear}[2]{\gdef\@yearen{#1}\gdef\@yearzh{#2}}
\DeclareRobustCommand{\defensemonth}[2]{\gdef\@monthen{#1}\gdef\@monthzh{#2}}
\DeclareRobustCommand{\defenseday}[1]{\gdef\@day{#1}}
\DeclareRobustCommand{\abstractname}[2]{\gdef\@abstractnameen{#1}\gdef\@abstractnamezh{#2}}
\DeclareRobustCommand{\acknowledgements}[2]{\gdef\@acknowledgementsen{#1}\gdef\@acknowledgementszh{#2}}

\abstractname{Abstract}{摘要}
\acknowledgements{Acknowledgements}{誌謝}

\DeclareRobustCommand{\clearpages}{\if@openright\cleardoublepage\else\clearpage\fi}

\DeclareRobustCommand{\makecover}{
  \begin{titlepage}
    \begin{singlespace}
    
    \begin{center}
      % 學校系所名稱 (18號字 標楷體)
      \fontsize{18}{27}\selectfont
      \@universityzh\@institutezh\par
      \vspace{0.8cm}
      
      % 學位論文 (18號字)
      \@typezh{}學位論文\par
      \vspace{3cm}
      
      % 論文中文題名 (20號字 標楷體)
      \fontsize{20}{30}\selectfont
      \@titlezh\par
      \vspace{1cm}
      
      % 論文英文題名 (16號字 Times New Roman)
      {\fontsize{16}{24}\selectfont
      \@titleen\par}
      \vspace{4cm}
      
      % 指導教授 (18號字 標楷體)
      \fontsize{18}{27}\selectfont
      指導教授：\@advisorzh\par
      \vspace{1cm}
      
      % 研究生 (18號字 標楷體)
      研究生：\@authorzh\quad 撰\par
      \vspace{3cm}
      
      % 中華民國年月 (18號字 標楷體)
      中華民國 \@yearzh 年 \@monthzh 月\par
    \end{center}
    \end{singlespace}
  \end{titlepage}
}


\DeclareRobustCommand{\makecertification}{
  \clearpages
  \begin{singlespace}
  \begin{center}
    \fontsize{24}{36}\selectfont\@universityzh\@typezh{}學位\@classzh\\
    口試委員會審定書\par
    \vspace{0.5cm}
    {\fontsize{20}{30}\selectfont\@titlezh\par\@titleen\par}
  \end{center}
  \addcontentsline{toc}{chapter}{口試委員會審定書}
  \vspace{1cm}
  \fontsize{15}{24}\selectfont
\hspace{30pt}本論文係\@authorzh{}君 (\@studentid)
在\@universityzh\@institutezh{}完成之\@typezh{}學位\@classzh，%
於民國 \@yearzh 年 \@monthzh 月 \@day 日%
承下列考試委員審查通過及口試及格，特此證明\par
  \end{singlespace}
  \vspace{\fill}
  \begin{center}
  \begin{doublespace}
  \fontsize{15}{30}\selectfont
  \begin{tabular}{p{2.75cm}p{12.5cm}}
    \raisebox{30pt}{口試委員：} & \rule{11.5cm}{1pt} \\
    & \rule{5cm}{1pt}\hspace{1.5cm}\rule{5cm}{1pt} \\
    & \rule{5cm}{1pt}\hspace{1.5cm}\rule{5cm}{1pt} \\
    & \rule{5cm}{1pt}\hspace{1.5cm}\rule{5cm}{1pt} \\
    & \rule{5cm}{1pt}\hspace{1.5cm}\rule{5cm}{1pt} \\
    \raisebox{5pt}{所\hspace{15pt}長：} & \rule{8.5cm}{1pt}
  \end{tabular}
  \end{doublespace}
  \end{center}
  \vspace*{-1cm}
}

\newenvironment{quotationpage}[1]
  {\clearpages
   \chapter*{\centerline{#1}}
   \addcontentsline{toc}{chapter}{#1}
   \quotation}
  {\endquotation}

\newenvironment{abstracten}{\begin{quotationpage}{\@abstractnameen}\begin{spacing}{\@doubleline}}{\end{spacing}\end{quotationpage}}
\newenvironment{abstractzh}{\begin{quotationpage}{\@abstractnamezh}\begin{spacing}{\@onehalfline}}{\end{spacing}\end{quotationpage}}
\newenvironment{acknowledgementsen}{\begin{quotationpage}{\@acknowledgementsen}\begin{spacing}{\@doubleline}}{\end{spacing}\end{quotationpage}}
\newenvironment{acknowledgementszh}{\begin{quotationpage}{\@acknowledgementszh}\begin{spacing}{\@onehalfline}}{\end{spacing}\end{quotationpage}}

% 設定counter
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{3}

\pagestyle{plain}
\@setspacing

% Avoid additional vertical stretching on pages with little content (e.g., headings near top)
\raggedbottom

% ToC, LoF, LoT centering settings with package tocloft
% Make list titles match \section size in zh mode (16pt with the same line spacing)
\renewcommand{\cftloftitlefont}{\hfill \fontsize{16}{18.4}\selectfont\bfseries}
\renewcommand{\cftafterloftitle}{\hfill}
\renewcommand{\cfttoctitlefont}{\hfil \fontsize{16}{18.4}\selectfont\bfseries}
\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cftlottitlefont}{\hfill \fontsize{16}{18.4}\selectfont\bfseries}
\renewcommand{\cftafterlottitle}{\hfill}

% Reduce vertical space before ToC/LoF/LoT title
\setlength{\cftbeforetoctitleskip}{0pt}
\setlength{\cftbeforeloftitleskip}{0pt}
\setlength{\cftbeforelottitleskip}{0pt}
\setlength{\cftaftertoctitleskip}{0pt}
\setlength{\cftafterloftitleskip}{0pt}
\setlength{\cftafterlottitleskip}{0pt}

% Set Reference Name
\renewcommand\bibname{Reference}

% 英文模式的章節格式
\titleformat{\chapter}[hang]{\fontsize{18}{27}\selectfont\bfseries}{\thechapter.}{1em}{}
\titlespacing*{\chapter}{0pt}{-3em}{20pt}

\titleformat{\section}[hang]{\fontsize{16}{24}\selectfont\bfseries}{\thesection}{1em}{}
\titlespacing*{\section}{0pt}{0pt}{6pt}

\titleformat{\subsection}[hang]{\fontsize{14}{21}\selectfont\bfseries}{\thesubsection}{1em}{}
\titlespacing*{\subsection}{0pt}{0pt}{6pt}

\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % dots for chapters
\titlecontents{chapter}[0em]{}{\makebox[1.5em][l]{\thecontentslabel.}}{}{\cftdotfill{\cftdotsep}\contentspage}

\makeatletter
\patchcmd{\@chapter}{\addtocontents{lot}{\protect\addvspace{10\p@}}}{}{}{}
\patchcmd{\@chapter}{\addtocontents{lof}{\protect\addvspace{10\p@}}}{}{}{}
\makeatother

% value > 0
\def\xeCJKembold{0.4}

% hack into xeCJK, you don't need to understand it
\def\saveCJKnode{\dimen255\lastkern}
\def\restoreCJKnode{\kern-\dimen255\kern\dimen255}

% save old definition of \CJKsymbol and \CJKpunctsymbol for CJK output
\let\CJKoldsymbol\CJKsymbol
\let\CJKoldpunctsymbol\CJKpunctsymbol

% apply pdf literal fake bold
\def\CJKfakeboldsymbol#1{%
  \special{pdf:literal direct 2 Tr \xeCJKembold\space w}%
  \CJKoldsymbol{#1}%
  \saveCJKnode
  \special{pdf:literal direct 0 Tr}%
  \restoreCJKnode}
\def\CJKfakeboldpunctsymbol#1{%
  \special{pdf:literal direct 2 Tr \xeCJKembold\space w}%
  \CJKoldpunctsymbol{#1}%
  \saveCJKnode
  \special{pdf:literal direct 0 Tr}%
  \restoreCJKnode}
\newcommand\CJKfakebold[1]{%
  \let\CJKsymbol\CJKfakeboldsymbol
  \let\CJKpunctsymbol\CJKfakeboldpunctsymbol
  #1%
  \let\CJKsymbol\CJKoldsymbol
  \let\CJKpunctsymbol\CJKoldpunctsymbol}
\newcommand\zhbf[1]{\CJKfakebold{#1}}

% set Chinese version
% 行距 = 字體大小 * 1.15
\ifzh

  % set two-character indentation
  \setlength{\parindent}{2em}

  % 中文數字（只吃 1–9）
  \DeclareRobustCommand{\naiveZhNum}[1]{%
    \ifnum#1=1 一\else
    \ifnum#1=2 二\else
    \ifnum#1=3 三\else
    \ifnum#1=4 四\else
    \ifnum#1=5 五\else
    \ifnum#1=6 六\else
    \ifnum#1=7 七\else
    \ifnum#1=8 八\else
    \ifnum#1=9 九\else
    #1%
    \fi\fi\fi\fi\fi\fi\fi\fi\fi
  }
  
  % 章
  \titleformat{\chapter}
    {\centering\fontsize{18}{20.7}\selectfont\bfseries}
    {第\naiveZhNum{\arabic{chapter}}章}{1em}{}

  \titlespacing*{\chapter}{0pt}{-3em}{9pt}
  
  % 節
  \titleformat{\section}
    {\centering\fontsize{16}{18.4}\selectfont\bfseries}
    {第\naiveZhNum{\arabic{section}}節}{1em}{}
  \titlespacing*{\section}{0pt}{0pt}{8pt}
  
  % 小節
  \titleformat{\subsection}
    {\fontsize{14}{16.1}\selectfont\bfseries}
    {\naiveZhNum{\arabic{subsection}}、}{0em}{}
  \titlespacing*{\subsection}{0pt}{0pt}{7pt}

  % 小小節
  \titleformat{\subsubsection}
    {\fontsize{12}{13.8}\selectfont\bfseries}
    {\arabic{subsubsection}. }{0em}{}
  \titlespacing*{\subsection}{0pt}{0pt}{6pt}


  \floatname{algorithm}{演算法}
  \renewcommand{\algorithmicrequire}{\textbf{輸入：}}
  \renewcommand{\algorithmicensure}{\textbf{輸出：}}


  \renewcommand{\contentsname}{目錄}
  \renewcommand{\listfigurename}{圖目錄}
  \renewcommand{\listtablename}{表目錄}
  \renewcommand{\tablename}{表}
  \renewcommand{\figurename}{圖}
  \renewcommand{\bibname}{參考文獻}

  \DeclareRobustCommand{\@startappendix}{
  \titleformat{\chapter}{\centering\fontsize{18}{27}\selectfont\bfseries}{附錄 \thechapter}{1em}{}
  \titlespacing*{\chapter}{0pt}{20pt}{20pt}
  \titlecontents{chapter}[0em]{}{\makebox[4.1em][l]{附錄 \thecontentslabel}}{}{\cftdotfill{\cftdotsep}\contentspage}
  \appendix}
\else
  \DeclareRobustCommand{\@startappendix}{\appendix}
\fi
