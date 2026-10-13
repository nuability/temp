# temp

## Qwen3.5-4B 模型压缩包

`models.zip` 原始大小为 **7,398,005,775 字节**（约 6.89 GiB）。文件按字节拆成 4 个分卷，存放在 [models-20261014 Release](https://github.com/nuability/temp/releases/tag/models-20261014)。下载全部分卷并合并后，即可解压原始 ZIP。

### 下载

将以下文件放在同一目录：

| 文件 | 大小（字节） |
| --- | ---: |
| [models.zip.001](https://github.com/nuability/temp/releases/download/models-20261014/models.zip.001) | 1,900,000,000 |
| [models.zip.002](https://github.com/nuability/temp/releases/download/models-20261014/models.zip.002) | 1,900,000,000 |
| [models.zip.003](https://github.com/nuability/temp/releases/download/models-20261014/models.zip.003) | 1,900,000,000 |
| [models.zip.004](https://github.com/nuability/temp/releases/download/models-20261014/models.zip.004) | 1,698,005,775 |
| [SHA256SUMS.txt](https://github.com/nuability/temp/releases/download/models-20261014/SHA256SUMS.txt) | SHA-256 校验清单 |
| [restore-models.ps1](https://github.com/nuability/temp/releases/download/models-20261014/restore-models.ps1) | Windows 合并和校验脚本 |

也可以使用 GitHub CLI 下载：

```sh
gh release download models-20261014 --repo nuability/temp --dir models-download
```

### Windows 合并

在下载目录中打开 PowerShell，运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\restore-models.ps1
```

脚本会检查全部 4 个分卷的 SHA-256，依次合并为 `models.zip`，再验证完整文件的 SHA-256。若目录中已经存在 `models.zip`，脚本会停止，避免覆盖。合并需要额外约 7.4 GB 可用空间；解压还需要更多空间。

### Linux / macOS 合并

确认当前目录没有需要保留的同名 `models.zip`，然后运行：

```sh
cat models.zip.001 models.zip.002 models.zip.003 models.zip.004 > models.zip
# Linux：校验分卷和合并后的文件
sha256sum -c SHA256SUMS.txt
# macOS：使用下方命令代替上一条
shasum -a 256 -c SHA256SUMS.txt
```

原始 `models.zip` 的 SHA-256：

```text
d253feabc2d2bb78689b04af8967c1e20803352563ed051749fec7d5240ba15f
```

这些分卷是原始 ZIP 的连续字节片段，不能单独解压。下载仓库的 **Code → Download ZIP** 或执行普通 `git clone` 只会得到说明、脚本和校验清单；模型分卷需要从上面的 Release 下载。
