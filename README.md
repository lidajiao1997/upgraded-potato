# bookedge —— 书边索引中文书籍模板

**bookedge** 是一套 XeLaTeX 中文书籍模板，核心特征是**书口索引（thumb index）**：每一章在页面外缘拥有一个专属颜色的色块，当前章加宽加深、其余章浅色占位。合上书，书口上就是一条完整的「色块阶梯」——像词典一样，凭拇指的手感就能翻到想要的章。

每章的专属色同时贯穿章号、节号、要点框、目录色签与页码徽章，形成章内一致的色彩氛围；「部」页整页铺该部主色的极浅底并加横色带，全书按部循环十色色板。

## 预览

| 封面 | 目录 |
|:---:|:---:|
| ![封面](preview/cover.png) | ![目录](preview/toc.png) |
| **部页** | **章首页** |
| ![部页](preview/part.png) | ![章首页](preview/chapter.png) |

书口索引条与章首导航尺（当前章 **01** 实色高亮，其余章浅色占位）：

![书口索引条](preview/tabs-zoom.png)
![导航尺](preview/ruler-zoom.png)

### 灰度版（黑白打印）

加类选项 `gray`，正文零改动。章节区分由十级灰阶承担（第 1 章最浅 → 第 10 章最深），当前章在索引条上改用**纯黑加宽**标记：

| 灰度封面 | 灰度目录 | 灰度章首页 |
|:---:|:---:|:---:|
| ![灰度封面](preview/gray-cover.png) | ![灰度目录](preview/gray-toc.png) | ![灰度章首页](preview/gray-chapter.png) |

## 特性

- **书口索引条**：每章一色、按页高均分槽位，当前章实色加宽；正面页在右缘（书口）、反面页在左缘，按**物理页序**判断，不受 `\pagenumbering` 页码重置影响；垫白页同样绘制，装订后阶梯连续不断档。
- **章首导航尺**：章首页顶部渲染全书章色缩略图，当前章高亮。
- **章色体系**：10 色低饱和色板自动循环，同一章色贯穿目录色签、章号、节号、项目符号、图文框与页码徽章。
- **完整书籍构件**：封面（右缘十色条）、扉页、版权页、部页、目录（彩色章节标签 + 点线）、`entry` / `notebox` / `examplebox` 三种图文框。
- **印刷规范默认**：`openright`——章与部一律起于正面（奇数页），必要时自动垫白；纯屏读可改 `openany`。
- **灰度打印**：`gray` 选项切换为 10 级灰阶 + 纯黑定位标记，深底白字 / 浅底深字自动适配。

## 与 `thumbs` 宏包的区别

CTAN 上已有的 [thumbs](https://ctan.org/pkg/thumbs) 宏包（v1.0q，2014）也能在页缘做拇指索引，但两者的设计模型不同。下面同一份中文书稿、同一个章节结构，分别用两个方案排出的实际效果：

![thumbs 与 bookedge 的实际对比](preview/compare-thumbs.png)

**核心差异：单个「爬行标记」vs 固定「全书阶梯」。**

- `thumbs` 的页缘**每页只画当前章的一个色块**（见左图：第二章的一页上只有蓝色"2"一块），块的垂直位置随章号逐级下移——用「位置」编码「你在哪」。
- bookedge 的页缘**同时画出全书每一章的色块**，排成一条固定竖梯，当前章实色加宽、其余章浅色占位（见右图）——用「整条阶梯」同时表达「全书结构」和「你在哪」。合上书，拇指扫过书口就能感知各章的相对位置与厚度，这是词典拇指索引的本意。

其他差异：

| | `thumbs` 宏包 | bookedge |
|---|---|---|
| 标记方式 | 手工：在每个标记点写 `\addthumb{标题}{文字}{字色}{底色}` | 自动：挂接 `\chapter`，无需手工标记，章总数从辅助文件自动统计 |
| 页缘呈现 | 仅当前对象一个块，随序号下移；槽高可压缩，放不下自动开新列 | 全章阶梯常驻；按页高 ÷ 章数自动均分槽位 |
| 配色 | 每个标记手工指定一对颜色 | 十色板自动循环，章色贯穿目录色签、节号、图文框、页码徽章 |
| 总览页 | **有**：`\thumbsoverview` 自动生成带超链接的「索引总览」（bookedge 目前没有这个功能） | 无（目录页的彩色章签承担类似功能） |
| 中文/ctex | 可用，但需显式 `\pagenumbering{arabic}` 否则 `pageslts` 报错（实测） | 基于 ctexbook 的书籍模板，中文排版、字体、开本开箱即用 |
| 定位 | 通用宏包，article/report 任意文档、任意对象都能加标记 | 书籍模板，索引条与章首导航尺、部页、封面是一套整体设计 |
| 黑白打印 | 需自己为每个标记选灰度 | `gray` 类选项一键切换十级灰阶 |

怎么选：想在**任意文档**里给任意位置加拇指标记、或需要带超链接的总览页——用 `thumbs`；在写一本**中文书**、想要词典式书口导航并与整套版式咬合——用 bookedge。

## 快速上手

把 `bookedge.cls` 与正文放在同一目录：

```latex
\documentclass{bookedge}          % 默认 openright；电子稿可用 openany；黑白打印用 gray
\bookedgetitle{书名}
\title{书名}
\epigraph{副书名}
\author{作者名\quad 编著}
\publishinfo{年份\quad 版次\quad 说明}
\begin{document}
\maketitle                        % 封面（右缘十色条自动绘制）
% 扉页、版权页写法参看 bookedge-demo.tex
\chapter*{前言}
\bookedgetabson                   % 从下一页起启用书边索引（建议放在目录前）
\tableofcontents
\mainmatter
\part{第一部分}
\chapter{第一章标题}
\begin{entry}{术语}{Foreign Term} % 词条框
术语解释正文……
\end{entry}
\begin{notebox}{要点}             % 要点框
要点内容……
\end{notebox}
正文……
\end{document}
```

编译（需 **XeLaTeX**，TeX Live / MiKTeX 均可）：

```bash
xelatex bookedge-demo.tex   # 连续编译 2–3 遍，至不再出现 Rerun 提示
# 或者一步到位：
latexmk -xelatex bookedge-demo.tex
```

多编译几遍是必需的：书口索引的章总数、`remember picture` 页面坐标都依赖辅助文件回传。

## 类选项

| 选项 | 说明 |
|---|---|
| `openright`（默认） | 章与部一律起于正面（奇数页），符合印刷书规范，必要时自动垫白 |
| `openany` | 章可从任意页开始，适合纯电子稿、屏幕阅读，不垫白 |
| `gray` | 灰度版：章节改用 10 级灰阶区分，供黑白打印，正文无需改动 |

## 主要接口

| 命令 / 环境 | 说明 |
|---|---|
| `\bookedgetitle{书名}` | 设置书名（反面页眉、PDF 元信息） |
| `\epigraph{副书名}` | 封面题词（书名下方） |
| `\publishinfo{…}` | 版权页信息（版次、开本等） |
| `\bookedgetabson` | 启用书边索引（建议放在 `\tableofcontents` 前） |
| `\bookedgetotal{n}` | 手工指定章总数（默认自动从辅助文件统计） |
| `entry` 环境 | `\begin{entry}{术语}{外文}` 词条框：章色标签 + 中外文对照 |
| `notebox` 环境 | `\begin{notebox}{标题}` 要点框 |
| `examplebox` 环境 | `\begin{examplebox}{标题}` 示例框 |

## 定制

- **换色板**：`bookedge.cls` 的「色板」一节有十条 `\definecolor`（`beC1`–`beC10`），改这里全书与索引条同步更新。
- **开本**：默认 170 mm × 240 mm、版心 118 mm，在导言区 `\geometry` 处调整。
- **索引条粗细**：`beWact` / `beWina`（当前章与其余章色块宽度，单位 pt）。
- **灰度深浅**：`gray` 模式下十条 `beC` 即十级灰阶，可在类文件「色板」处微调档距。

## 已知约定

- 全书章数 ≤ 10 时索引一色一章；超过 10 章色板自动循环、索引条变薄，建议改以「部」分色。
- 封面、扉页、版权页不显示索引；从目录页起索引以全浅色状态出现，相当于全书图例。
- 附录等 `\chapter*` 页沿用前一章的颜色与索引位置。
- 索引条与页眉的左右取向按物理页序判断，正文重置页码（如 `\mainmatter`）也不影响色块落位。

## 文件

```
bookedge.cls            类文件（唯一必需）
bookedge-demo.tex       示例书稿《书的模样》（31 页，含全部功能）
bookedge-README.tex     使用说明（xelatex 编译出 bookedge-README.pdf）
```

## 环境要求

- TeX Live 2022+ 或 MiKTeX（含 `ctex`、`tikz`、`tcolorbox`、`titletoc`、`eso-pic`、`fancyhdr` 等常用包）
- 中文主字体使用 Fandol（TeX Live 自带）；无衬线字体默认取 Windows 的 Noto Sans SC，其他平台可在类文件「字体」一节替换

## License

[MIT](LICENSE)
