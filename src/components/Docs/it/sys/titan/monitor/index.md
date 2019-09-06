<style lang='stylus' scoped>

</style>

<a-col :md="8" :lg="2" class="menu">

</a-col>

<a-col :md="24" :lg="18" class="markdown-body">

# Titan 监控系统使用手册

[[toc]]

<br><br><br><br><br><br><br><br><br><br><br><br><br>

## 简介

`Titan` 有 6 台生产服务器，1 台开发机，由 `perl` 编写的监控系统部署在开发机上，可以覆盖服务器 `EQ1`/`EQ2`/`QC1`/`QC2`，定期执行监控命令，解析输出日志，然后将警告内容发送至指定的邮箱。

|别名|hostname|IP|
|---|---|---|
|EQ1|tn1s003|10.53.144.13|
|EQ2|tn1s004|10.53.144.14|
|EQ3|tn1s005|10.53.144.5|
|EQ4|tn1s006|10.53.144.6|
|QC1|tn1s001|10.53.144.17|
|QC2|tn1s002|10.53.144.18|
|DEV|tn1g001|10.53.144.180|

## 配置文件

使用 `relayn1` 用户登录开发机，配置文件位于 `/package/relayn1/etc` 下，分别为：

- `A00_ping.conf`
- `A01_rsh.conf`
- `B00_oracle.conf`
- `B01_ttnrun.conf`
- `C00_oralog.conf`
- `C01_ttnlog.conf`
- `C02_disk.conf`
- `C03_tspace.conf`
- `C04_dirwatch.conf`
- `mail.conf`

### 邮箱配置

编辑邮箱配置文件 `mail.conf`，在 `@MailTo_1` 字段添加接收警告内容的邮箱：

```txt
@MailTo_1 = (
     'titanmail@cecpandalcd.com.cn'
);
```

添加邮箱服务器地址：

```
$SmtpServer = '172.23.20.30';
```

> 备注1：邮箱服务器端口不需要配置，默认为 25。

> 备注2：目前开发机 `10.53.144.180` 和 `172.23.20.30:25` 的网络是相通的，否则，请联系网络工程师。

> 备注3：为什么只配置了接收邮件的邮箱，而邮件是怎么发送出来的呢？原因是邮箱服务器 `172.23.20.30` 不需要认证授权也能发出邮件，发件人可以任意填写。在 `Titan` 监控系统中默认使用 `Titan Dev Relayn1`。

### 命令配置

监控命令配置文件可以根据具体情况自行调节参数：

#### ping

`A00_ping.conf`：
```
# check of remote shell

## count of ping packets
$PingCount = 3;

## ping timeout sec (may not use)
$PingTimeout = 10;

## title string
$Title = '*** CRITICAL *** No response by PING';
```

#### rsh

`A01_rsh.conf`：
```
# check of remote shell

## title string
$Title = '*** CRITICAL *** No response from Remote Shell'; 
```
#### oracle

`B00_oracle.conf`：
```
# check of DB availability

## sql script
$OraSQL = "/package/relayn1/sql/oracle.sql";

## title string
$Title = '*** ERROR *** ORACLE is not available';
```
#### titan-run

`B01_ttnrun.conf`：
```
# check of TITAN running

## days to ignore old logs
$TtnLogDays = 1;

## time (hour) to check log update
$TtnLogUpd = 0.25;

## sql script
$TtnRunSQL = "/package/relayn1/sql/ttnrun.sql";

## title string
$Title = "*** ERROR *** No log output from TITAN, past $TtnLogUpd hours";
$SubTitle = '--- Last log ---';
```

#### oracle-log

`C00_oralog.conf`：
```
# check of DB alert log

## alertlog files
@OraLogs = (
  "/package/oracle/oracle11/app/oracle/diag/rdbms/ora11/ora11/trace/alert_ora11.log"
);

## max tail lines count of logfile   (*Note* 20KB limit on HPUX)
$OraLogTail = 400;

## days to ignore old logs
$OraLogDays = 15;

## title string
$Title = '*** WARNING *** ORACLE alert log has found';
```

#### titan-log

`C01_ttnlog.conf`：
```
# check of TITAN system log

## sql script
$TtnLogSQL = "../sql/ttnlog.sql";

## path To IgnoreList
$PathToIgnoreList = "../etc/IgnoreList";

## path to LastTryFile
$PathToLastTry = "../sts/$TargetNode/ttnlog.ex";

## title string
$Title = '*** WARNING *** TITAN error log has found';

## number of cols to be selected (refer to sql file)
$SelectCols = 8;

## cols to mail (starts from 1)
@ColsToMail = (1, 2, 3, 4, 5, 6, 7, 8);

## col max len (round col length)
$ColMaxLen = 150;

## default select range (sec)
$DefaultSelectRange = 600;
```

#### disk

`C02_disk.conf`：
```
# check of disk space

## threshold values
%DskPerc = (
 ## (mount point)        (%)
 '/',           80,
 '/stand',      80,
 '/work',       80,
 '/var',        80,
 '/usr',        80,
 '/tmp',        80,
 '/package',        90,
 '/opt',        80,
 '/ftp',        70,
 '/dbs01',      90
);

## title string
$Title = '*** WARNING *** Disk free space has reached the warning value';

```

#### tspace

`C03_tspace.conf`：
```
# check of DB table space

## threshold values
%TSpcPerc = (
 ## (tspace name)    (%)
 'TITAN_DAT1',          70,
 'TITAN_DAT2',          70,
 'TITAN_IDX1',          70,
 'TITAN_IDX2',          70,
 'TITAN_MASTER',        70,
 'TITAN_TEMP',          80,
 'UNDOTBS1',        80
);

## sql script
$TSpcSQL = "/package/relayn1/sql/tspace.sql";

## title string
$Title = '*** WARNING *** DB-TableSpace has reached the warning value';
```

#### dirwatch

`C04_dirwatch.conf`：
```
# titan data directry file count check

%TgtDirList = (
    #eq common
    '/package/titann1/data/lock_file/*.lock'  ,200,
   
    # ......

    '/ftp/work/haishin_data/qc2/*.req'      ,1000,  # eq  only
);

## title string
$Title = '*** WARNING *** Too many data files in data dir';
```

## 启动

执行 `EQ1` 监控的命令如下：
```bash
% su - relayn1
% cd /package/relayn1/run/
% perl mail.pl eq1
```

但是在正式环境下，我们使用 `cron` 定时执行监控命令：
```sh
% pwd
/package/relayn1
% 
% cat crontab.bak
0,30 * * * *        perl /package/relayn1/run/main.pl qc1
0,30 * * * *        perl /package/relayn1/run/main.pl qc2
0,30 * * * *        perl /package/relayn1/run/main.pl eq1
0,30 * * * *        perl /package/relayn1/run/main.pl eq2
%
# 启动 cron
% cat crontab.bak | crontab - > /dev/null
```
执行频率可根据实际情况自行调整。

## 停止

停止 `cron`：
```sh
(relayn1@tn1g001)113% whoami
relayn1
(relayn1@tn1g001)114% crontab -r
```

</a-col>
<a-col :md="8" :lg="4">

<!-- [toc]
 -->
</a-col>
