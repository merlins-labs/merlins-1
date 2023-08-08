#!/bin/bash
set -e

export validator1Mnemonic="drill sad rare much heart vacant human access pond solar spare remove electric remain maximum poem phone fish gorilla van payment bag member fine"

export validator2Mnemonic="ability taxi slide daring team stamp artist journey leisure detail ordinary unfold enter crush doll vague anchor meat angry text learn monitor wrong gauge"

export validator3Mnemonic="vehicle find leg ahead tornado busy south bid width rifle violin scan joy carpet charge name mother scale vital decade ordinary good tennis sort"

export validator4Mnemonic="organ stove tell clay knee pond guide cry shrug hood way put penalty million hockey despair only electric ethics kitten ostrich right glue peasant"

export validator5Mnemonic="brief hundred army design kidney topic energy oyster airport caught sound chunk surge rain coyote fee demand shrimp prison rigid expire high soldier roof"

export validator6Mnemonic="voice satoshi boil draft brain taste door cigar boat story gun delay draw position fabric luxury speak eternal action hello payment win actor prepare"

export validator7Mnemonic="foam skill possible fatal mule sweet decorate range region puzzle guess fossil sunny chuckle together program stock poet wall alley execute property diesel obey"

export validator8Mnemonic="play plate major arrive sauce census glory mushroom allow cash pottery smile earn price mango hood panda check require blur dragon inner apple fix"

export validator9Mnemonic="require below ski victory west ordinary club kitchen tobacco candy ecology magnet story boil file exhaust vital theme drama measure banner guard hero primary"

export faucetMnemonic="hair color duty october move bracket deny crisp have awesome tornado syrup veteran modify enemy potato beauty retreat play exact sunny salute area april"

# always returns true so set -e doesn't exit if it is not running.
killall merlin || true
rm -rf $HOME/.merlin/
BINARY=merlin

# make four merlin directories
mkdir $HOME/.merlin
mkdir $HOME/.merlin/validator2
mkdir $HOME/.merlin/validator3
mkdir $HOME/.merlin/validator4
mkdir $HOME/.merlin/validator5
mkdir $HOME/.merlin/validator6
mkdir $HOME/.merlin/validator7
mkdir $HOME/.merlin/validator8
mkdir $HOME/.merlin/validator9
# init all three validators
merlin init --chain-id="blackfury-1" validator1 
merlin init --chain-id="blackfury-1" validator2 --home=$HOME/.merlin/validator2
merlin init --chain-id="blackfury-1" validator3 --home=$HOME/.merlin/validator3
merlin init --chain-id="blackfury-1" validator1 --home=$HOME/.merlin/validator4
merlin init --chain-id="blackfury-1" validator2 --home=$HOME/.merlin/validator5
merlin init --chain-id="blackfury-1" validator3 --home=$HOME/.merlin/validator6
merlin init --chain-id="blackfury-1" validator1 --home=$HOME/.merlin/validator7
merlin init --chain-id="blackfury-1" validator2 --home=$HOME/.merlin/validator8
merlin init --chain-id="blackfury-1" validator3 --home=$HOME/.merlin/validator9
# create keys for all three validators
printf "$validator1Mnemonic\n" | merlin keys add validator1 --keyring-backend=test --home=$HOME/.merlin --recover 
printf "$validator2Mnemonic\n" | merlin keys add validator2 --keyring-backend=test --home=$HOME/.merlin/validator2 --recover 
printf "$validator3Mnemonic\n" | merlin keys add validator3 --keyring-backend=test --home=$HOME/.merlin/validator3 --recover 
printf "$validator4Mnemonic\n" | merlin keys add validator4 --keyring-backend=test --home=$HOME/.merlin/validator4 --recover 
printf "$validator5Mnemonic\n" | merlin keys add validator5 --keyring-backend=test --home=$HOME/.merlin/validator5 --recover 
printf "$validator6Mnemonic\n" | merlin keys add validator6 --keyring-backend=test --home=$HOME/.merlin/validator6 --recover 
printf "$validator7Mnemonic\n" | merlin keys add validator7 --keyring-backend=test --home=$HOME/.merlin/validator7 --recover 
printf "$validator8Mnemonic\n" | merlin keys add validator8 --keyring-backend=test --home=$HOME/.merlin/validator8 --recover
printf "$validator9Mnemonic\n" | merlin keys add validator9 --keyring-backend=test --home=$HOME/.merlin/validator9 --recover 

update_genesis () {    
    cat $HOME/.merlin/config/genesis.json | jq "$1" > $HOME/.merlin/config/tmp_genesis.json && mv $HOME/.merlin/config/tmp_genesis.json $HOME/.merlin/config/genesis.json
}

# change staking denom to ufury
update_genesis '.app_state["staking"]["params"]["bond_denom"]="ufury"'

# create validator node with tokens to transfer to the three other nodes
merlin add-genesis-account $(merlin keys show validator1 -a --keyring-backend=test) 1500000000000ufury,1000000000000umer --home=$HOME/.merlin

merlin keys add airdropKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account airdropKeyName 79000100000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add airdropvestedKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account airdropvestedKeyName 100000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add whitelistKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account whitelistKeyName 5000010000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add bondingKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account bondingKeyName 31501000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add bondingvestedKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account bondingvestedKeyName 1000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add seedKeyName --keyring-backend test
merlin add-genesis-account seedKeyName 4488671232877ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin --vesting-amount  4487671232877ufury --vesting-start-time 1668018600 --vesting-end-time 1699640700

merlin keys add privateKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account privateKeyName 8078808219178ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin --vesting-amount  8077808219178ufury --vesting-start-time 1668018600 --vesting-end-time 1699640700

merlin keys add bonusKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account bonusKeyName 1078041095890ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin --vesting-amount  1077041095890ufury --vesting-start-time 1668018600 --vesting-end-time 1699640700

merlin keys add atloKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account atloKeyName 717301369863ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin --vesting-amount  716301369863ufury --vesting-start-time 1668018600 --vesting-end-time 1699640700

merlin keys add valkyrieKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account valkyrieKeyName 4201000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add publicKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account publicKeyName 25831000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add marketingKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account marketingKeyName 32761000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add advisorsKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account advisorsKeyName 14701000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add advisorsvestedKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account advisorsvestedKeyName 1000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin 

merlin keys add teamKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account teamKeyName 63001000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add treasuryKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account treasuryKeyName 41001000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add treasuryvestedKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account treasuryvestedKeyName 1000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add ecoKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account ecoKeyName 21001000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add ecovestedKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account ecovestedKeyName 1000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add liquidityKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account liquidityKeyName 21001000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add liquidityvestedKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account liquidityvestedKeyName 1000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin

merlin keys add faucetKeyName --keyring-backend test --home=$HOME/.merlin
merlin add-genesis-account faucetKeyName 101000000000ufury,1000000000umer --keyring-backend test --home=$HOME/.merlin


# create investors

$BINARY add-genesis-account fury1f02wg3dawqdwjv7ak7e6vh2u6sjf5s26um7wa2 2722500000000ufury,1000000000umer
$BINARY add-genesis-account fury1jl2zcz32npjgs88vd60xv5qan5rtzh4xvrsy9m 9375000000000ufury,1000000000umer
$BINARY add-genesis-account fury1kfr4wznhwelzhal8gc8es67tcx4g4tsycpxuru 214286250000ufury,1000000000umer
$BINARY add-genesis-account fury129kdy7qdk5r4qgrenqdd6ftjjuvcc3hqxtuxey 243621661507ufury,1000000000umer
$BINARY add-genesis-account fury1e6m3jymsgetz5vyvkvujejqufanpq8mg8wq4h3 2747500000000ufury,1000000000umer
$BINARY add-genesis-account fury1hyxea0xa08wv4y30v5q9g2jwls8cgdk6uag47z 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury1mhv5w6up9ltlwe7ekgfpjhd0upn4f7umdqwsmc 964285500000ufury,1000000000umer
$BINARY add-genesis-account fury17w74x9vrqq4a338ssh9y9r4m9s3f6zefgphm2l 214286250000ufury,1000000000umer
$BINARY add-genesis-account fury1d03ppywn369qzajeuqs0dge29rchxteakjru0m 825000000000ufury,1000000000umer
$BINARY add-genesis-account fury1azg0gpgatmzr60mzya9d774eude263efqvcf3m 214286250000ufury,1000000000umer
$BINARY add-genesis-account fury1tz80tk5295jafft5njnvvxgnvcf63y3v57rpqd 471429000000ufury,1000000000umer
$BINARY add-genesis-account fury15y4xh9xj2lm9ll4usturv4qdugr5t0gn8mkdja 642857250000ufury,1000000000umer
$BINARY add-genesis-account fury136qxshkaf78ucuff4kdc8srw73k2x0adxdx295 447856500000ufury,1000000000umer
$BINARY add-genesis-account fury162cxa76zpvag4a05da0yhu69awfy35w8hpr4mm 364286250000ufury,1000000000umer
$BINARY add-genesis-account fury1w33lkcauxeyrq8nn3f6h9cgncxuxdrzmyqke5s 1060713750000ufury,1000000000umer
$BINARY add-genesis-account fury1t2rkh00d000qzlyj2l2l8z5hy34a3e733fh8zw 235713750000ufury,1000000000umer
$BINARY add-genesis-account fury1vdl5mwqkpepvsacckr50m8eyk80hqp23xk3y5d 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury1ssfpxgkzt4yj0unmzx0cmrx6mhm5kl0gu5ltqe 495000000000ufury,1000000000umer
$BINARY add-genesis-account fury1nthsvkmqdl4qmeg0qh40s0jrjpquncdyq84vl3 3000000000000ufury,1000000000umer
$BINARY add-genesis-account fury1ejtqghtlhauyqag8xphnkltvqjuxwl5sll63xg 353571000000ufury,1000000000umer
$BINARY add-genesis-account fury1tluyekggnce4js7usrs0xk06528vg99rtqkjgg 214286250000ufury,1000000000umer
$BINARY add-genesis-account fury1lldkcxprlhqknnal3w0wp2fe0mlhyzdcrfd9wg 1178571750000ufury,1000000000umer
$BINARY add-genesis-account fury1kml5p8et0j7zhqptxla74nf0gfsumcy76z8t03 2142857250000ufury,1000000000umer
$BINARY add-genesis-account fury10le9zwrp6x9t6xcg4ws2j8rsvggvktaj6jlah2 282856500000ufury,1000000000umer
$BINARY add-genesis-account fury1vc8772tklysj5ryaz2s0kx66k4fw3x3y2x76nx 105000000000ufury,1000000000umer
$BINARY add-genesis-account fury1k03n5tcj6f7d6zkjp3xvl8h6hp05vprlxha9qn 642857250000ufury,1000000000umer
$BINARY add-genesis-account fury17u9m4sgfg3ahdenacfq4j6uzm4qucf5ujcaj3j 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury1r796wq2hn0k7yf8kcqrmlxqmf3ys4pdyd66let 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury1y0lufpa3yfnwrjk5lfz3zcl9hq6stmdhh5zn6h 353571750000ufury,1000000000umer
$BINARY add-genesis-account fury1ya8d8u6assqy0wyvdhg9kuud69z9gkjpmdphnx 437500000000ufury,1000000000umer
$BINARY add-genesis-account fury1e5ag4a5wlckwzlz4wu87p6nxjp427zpmw6d6n8 428572500000ufury,1000000000umer
$BINARY add-genesis-account fury1vmk950mvwakjef3qjjpcz9f28x3ah3q8p08kda 42857250000ufury,1000000000umer
$BINARY add-genesis-account fury1qksggyhumezsdmeelqrvhdyh2n6nshmuehmcue 214286250000ufury,1000000000umer
$BINARY add-genesis-account fury152a6ympm8pmpmn3z8rxka6gdj96ssu7rcrptxm 16815750000ufury,1000000000umer
$BINARY add-genesis-account fury17xdjy3t0dtqhxzlk7dxmm32j7u7krfn3xpqtg9 428571000000ufury,1000000000umer
$BINARY add-genesis-account fury19k85gsahz45qr86gn5t0ym7zac8nlm6v3e8wpg 107143500000ufury,1000000000umer
$BINARY add-genesis-account fury1gyvgpngr3saypgdud0etzj74q56vy97spup8up 113142000000ufury,1000000000umer
$BINARY add-genesis-account fury1fs2yal2cs89mqnn389ap3rh5z842llfh8kdfxh 321428250000ufury,1000000000umer
$BINARY add-genesis-account fury1zy2usgrg4ywh7e3j8qychvxarp4y5shf58zdc5 21429000000ufury,1000000000umer
$BINARY add-genesis-account fury1xeve8vkkltsd9uzaqya78ywtspyc35hr6lleay 94293750000ufury,1000000000umer
$BINARY add-genesis-account fury1qvesqkksz3nyrys5gvlryfj8zv90pz9qjjw4qn 642857250000ufury,1000000000umer
$BINARY add-genesis-account fury1czemphdmk0j9vn6gspj454p24rs5jz4gfdyvcy 136713750000ufury,1000000000umer
$BINARY add-genesis-account fury147ck7dxylz7d4mrjw7r6g2sdx6j3vmdspjjsxg 70500000000ufury,1000000000umer
$BINARY add-genesis-account fury1kndgwd8vtn38zhq5ae8yjm5ez7sz3xy5x2l3hp 67500000000ufury,1000000000umer
$BINARY add-genesis-account fury14z8wsgf807e3hxuny5laaxtn0ytvcj9qs5jq87 330000000000ufury,1000000000umer
$BINARY add-genesis-account fury158343p7g7qlw76ph5dzvtvk5tztegz3g24p8ns 132000000000ufury,1000000000umer
$BINARY add-genesis-account fury1d4ulqc7y3pqe5lxdwv0sl7cd9qnkjturmmfhr7 5357143500000ufury,1000000000umer
$BINARY add-genesis-account fury1hcgqp24ps3n09pk4ugu7tscj72q25r8rp808xg 183856500000ufury,1000000000umer
$BINARY add-genesis-account fury1uxylhand5q6j3xg2qxwzl9hez7a20j8alwqx0r 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury12l4ehyq5qzsmvapa5a8ls9sr65q8yf080qqh6x 535714500000ufury,1000000000umer
$BINARY add-genesis-account fury120fza5vukwmaksphtqesrh4kqxf8er6ewmlj6t 4455000000000ufury,1000000000umer
$BINARY add-genesis-account fury1quchug9sa22z9x7hkus98wgl8j503aq0m5syt2 90000000000ufury,1000000000umer
$BINARY add-genesis-account fury1rq048x4ducr9nqze48g55x0q57e8lthx9yj46y 136713750000ufury,1000000000umer
$BINARY add-genesis-account fury1clwgp88d7aq2nhk5mmwk2w82t67n3fgk9aczuv 154286250000ufury,1000000000umer
$BINARY add-genesis-account fury1vum9yv6gtd54kpgdhd37p5z097ngphlfced867 235713750000ufury,1000000000umer
$BINARY add-genesis-account fury1t0lzffhd5yhclj4pmhxp4h82nxfr08c5jf07xz 825000000000ufury,1000000000umer
$BINARY add-genesis-account fury14zeskm5s4yz75fd4r70m37u37wfzt9lpvhf4ts 28929000000ufury,1000000000umer
$BINARY add-genesis-account fury1qws9l50tvnmfx0hrek9500dzygv92rj4m7u0u0 214286250000ufury,1000000000umer
$BINARY add-genesis-account fury15wcg9d228whk85zf4rde7nypn09htc2gjp2k85 183856500000ufury,1000000000umer
$BINARY add-genesis-account fury1as8j8qhexvsc3sy0gxrfajuuggwar45cpxy0lu 99000000000ufury,1000000000umer
$BINARY add-genesis-account fury1l4ml9eklv84zpm0968jt4hezwaymwr6kx76qsn 81750000000ufury,1000000000umer
$BINARY add-genesis-account fury1jhpwxpadlx8ax429ljm5rrqm2pse4sgf2rrkv8 424284750000ufury,1000000000umer
$BINARY add-genesis-account fury1es9fu48yxwd9jdweaykjaf0fr7usw3x0gr6l3r 165000000000ufury,1000000000umer
$BINARY add-genesis-account fury1mz6dr3yzdvnnaeg3e6mgvuwnluq63ep38ghkwr 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury1526zhyrd8fzdvzayct9yfnspsdp9uuqhjagyg7 559992922951ufury,1000000000umer
$BINARY add-genesis-account fury19umlsn9fc3ytfe9s3l9dez4z2ujjljqj8pjz2f 3125000000000ufury,1000000000umer
$BINARY add-genesis-account fury1ja4jpkvf9tw5w9pt3futxq6hxs5lwf849w268k 105000000000ufury,1000000000umer
$BINARY add-genesis-account fury1wknw5glel2jekejuehn4auvfs7dhqf6zl2ud2h 66000000000ufury,1000000000umer
$BINARY add-genesis-account fury12zquqgw5ejaxphfeqh3ycduuwmvpennkad8ztm 79500000000ufury,1000000000umer
$BINARY add-genesis-account fury1al3k6rd4u550gcvfwd7akl032su2y2vtye0ggp 127284750000ufury,1000000000umer
$BINARY add-genesis-account fury1r76xl88z8payyt0zx333c5v5hh5rjp2a5yqdas 7500000000ufury,1000000000umer
$BINARY add-genesis-account fury1cwk4s0jtvt69mawaqsay2a9h20cgqd9hzhe0ee 3881190250000ufury,1000000000umer
$BINARY add-genesis-account fury1kah8qvju0h5g0nslsfhvznrsw0jrhnry2zm2hs 428571750000ufury,1000000000umer

# create atlo

$BINARY add-genesis-account fury1002743yxn0akwdh77389sl88zslh0a7nlnrh5f 23610321935ufury,1000000000umer
$BINARY add-genesis-account fury100dxspkurxsa29upl7s9pywqxtff70r6f20fmn 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury105jq8c946et7wss2qkscaagg96pf78zusg2gwj 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1072q7txl66nc5zfyexe0wk3m6w05jy88tvqvv6 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1093vkqkxf6fnlwwyqn7x6xpa3u628jv2f8zn5v 8493333333ufury,1000000000umer
$BINARY add-genesis-account fury10e2y0ynnywnry3tkypk0qajtzncmfzlp7pcysc 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury10eq2e6f3saedl0399cy9dze5xnlsz0s57td0u9 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury10g88n7pgyxhfg698dqggandqujvjzrd3hkyckr 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury10hryzctz898clsrm802kknyj4l6kayua0ssqwn 6597270358ufury,1000000000umer
$BINARY add-genesis-account fury10hyvlccpjq6myak86ga7reaf7h2pgm4ergw2cw 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury10krpx786styrfd7egy2rh39mue4dthg498hn6j 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury10lwmun98vpv9fuup2jnjvwp70a9778ra3ynas5 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury10ne863spcj46y5x9n5z0rp7gxhk8wzp5ahz0sd 5824000000ufury,1000000000umer
$BINARY add-genesis-account fury10ns8957mvpkwahez27rlml50vse0hxyghwjzus 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury10p9gcyapphzf3p07uqskyfzwe8v55slmqsxsly 1274000000ufury,1000000000umer
$BINARY add-genesis-account fury10qh429jqjqcmnc5cm38me74zczekm0kmrhuutj 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury10r69d9sny2eycchu3wnlxwk0xvlhwew5jfwj90 1972306221ufury,1000000000umer
$BINARY add-genesis-account fury10wnsmyl9m2k6r3xvrefxpulusq7mym4mn0x9ld 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury10yxan7x3ug0cd8qaev849edm4ajy9zfeewg7hj 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury10zjqdvghyqxw347rxcp6j6wxl2rs9dzf38tf8k 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1237a8r7qs8ewqwwyycn59tdq9zz2r0s34ssmj3 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury125ef7a88ujk05up2j59m9fwdrvy0w052kjjqws 24266666667ufury,1000000000umer
$BINARY add-genesis-account fury12668fgtdsqvvg2z74q92rn8z3hfcvmwv6qquzn 2684264144ufury,1000000000umer
$BINARY add-genesis-account fury126fjj6j9q3fn2zqdeurqlqvw4u02nqzz2e25ae 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury128a0x45q0fn6tx5lwzeec7l0sdxlktqect0yxt 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1295etyk99ra5x3e2suvyp5yv7jd5wcryx2y5f9 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury12agmjfvadtyg0ak3ravwu24apyraglz3vxnwme 3700391980ufury,1000000000umer
$BINARY add-genesis-account fury12ah4s382ggtmdm4axa094men54yn082fwlq8lw 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury12c6kkw8hyqdsphrraj9jkxkwca59fycf4kfy06 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury12fdsdtl09qwrtq06zs349u6law4v77x0czvuz2 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury12fkgdllkz4sncycuc2hykmxjq69t6vk42wu2zv 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury12ga8rw9nrm98ffpnfjucfwkrfhqqffeedyyta7 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury12gstuntpp4pv6vz2xs46cm5ql9yul32cajerqr 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury12k7qqej7y3ezu5ztqaaum6yxgex0dkj949vyke 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury12ljuyyzf800gz5cjrwcg3u3qj0xt7jhvruuhuz 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury12lvdjakpk3npasvt42zxer804ah7rn66pmwap9 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury12rlaudq0wkcj4r83yp039sdhurt5d72qmwpp7r 2366000000ufury,1000000000umer
$BINARY add-genesis-account fury12sts35ekqw26tpaqh2xehuw6hjly2zuylvu7j7 1306524693ufury,1000000000umer
$BINARY add-genesis-account fury12t5nw5htu9dcggz0dczv5g02m3eqfp6skfkuee 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury12tr8f5vc5mtax6zfc5tsn32v30pqutcssrqq2m 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury12tvm848rmnse0hshc5hdp3flnklpv5425te40y 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury12w2d60cs77trtvcn3lrw20e6th2ge3vh43l00t 6430666667ufury,1000000000umer
$BINARY add-genesis-account fury12ya4x8ztxx5yyrnn3hxs2gfmhdjmf0fh7zcm4n 3518761480ufury,1000000000umer
$BINARY add-genesis-account fury130tmnwllvc0u620222umc67h0clehfp8l9relc 60666666667ufury,1000000000umer
$BINARY add-genesis-account fury130znx0awxt5mmjvd59qh580a8df6drktwg4tsy 14972617072ufury,1000000000umer
$BINARY add-genesis-account fury13264y07zjvrvcm3w4vlhdu06ya6q6308r6c2wu 10910298114ufury,1000000000umer
$BINARY add-genesis-account fury132e4esk4dddk6e27fd77npav0hcct5k2uzghgk 17343253958ufury,1000000000umer
$BINARY add-genesis-account fury1346vec6kj4qav2t7fkpu5h4nx90fae36cgfeyd 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury13chnzuqnkzl389ddsv0jf0m7mgmmvzmwjq4av2 1797290179ufury,1000000000umer
$BINARY add-genesis-account fury13fa9gg76jwyc4lfkgz3k4lalrjx4xn6nrp6t5m 5824638173ufury,1000000000umer
$BINARY add-genesis-account fury13revek9qld9geyfc2autgm6t8khhcv9mkj5et6 10116951226ufury,1000000000umer
$BINARY add-genesis-account fury13sa5zhy5w2upasszcx8hepy7g47f3p0vwtdmth 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury13sn3v9zq27tkd8d653ve2cmtazdnnxxrzzsp7p 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury13sq3zm8gt329cvtq48s89krl0z32wwq37p33f5 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury13t23zct67vm2034glgzk4jz4ylwhkzwxmr3w9q 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury13t2q8xua7pvpealfqzstn06elxpnaq2auxxn96 5460000000ufury,1000000000umer
$BINARY add-genesis-account fury13tm0q5uksuphjhldfpnkp8sscxw7wm4fk49cdh 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury13ucdlvclmhd8eh823u890cv3ysjg38nl8qfedw 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury13vk0wseqr9r2jq5h4yde0c9y5prn6ppcrghz5j 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury13y270e2cf9zmu32wwyxldu8srvvyfkwmj5ukee 4125333333ufury,1000000000umer
$BINARY add-genesis-account fury140um009t5my80e75rxwvg5sc0qpv3wcv867rek 9323301242ufury,1000000000umer
$BINARY add-genesis-account fury143c39hwvjwydcl8h80avt57s6aseft27g7a2z8 1424368079ufury,1000000000umer
$BINARY add-genesis-account fury144wt8jaeucylhh5vz9zdtdwn7kpzl3zjd8flel 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury14698rl89hk8h2k23u99dgflw4tsxha8p45xl68 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury146smxctaxdahuvuzw8cuj85hum6jqecslxumx5 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury147uxgtche0raru7dedst75a7lzx34ydq9mwt47 15878782896ufury,1000000000umer
$BINARY add-genesis-account fury147v8s6ndlazvqme2qa4j9s43qy8zw8u3ts66fv 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1497y0nzp6yfwrw6ercwkf23mpura9tjq6k9lty 3930414701ufury,1000000000umer
$BINARY add-genesis-account fury14dmwl0m45alcm8lv3kywn0jem03l8v69k99uzd 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury14gam5fayxaygkag6s295f6c0a4rhm8w0f4szzy 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury14gkqshay6d7kfyx3mts3lgpc0hn3ctk5ds8d35 1456000000ufury,1000000000umer
$BINARY add-genesis-account fury14jr7t8cqhf2c60vjk4r2vq52emszsd8pqnatfp 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury14kh5v704e63l64254pu6ws6ndcnenuy0uv7z0a 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury14m97zejmhx9anfep2jpkmnpuggxx8gahxwnsu2 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury14nvay3vwhqve6v4cddnzd4d2jk5krfgfpwrvm0 4368000000ufury,1000000000umer
$BINARY add-genesis-account fury14p3gp3l7z9q6nh49qhcr24ae6fgne7lyal0vmd 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury14pg2tpnrlj23m65sg8ft9m0safrk3d56dvtqtp 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury14q9mmpkc4n0cx3ezm8lvuzuvnt3dgjn6q0k87k 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury14qp43n08c8la4yvfzqaqrvtln2yuqyqjn84a7x 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury14r9pgh530knz34g7tg68n77f4dj5zpemv4yvu0 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury14s3nyfue5hj759rxe0pu4xgfr0236kxpn0ljux 36400000000ufury,1000000000umer
$BINARY add-genesis-account fury14tdsywzgsqd3kctlvyx6nz0dyhdeuypxge2sg8 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury14xy6duknx50mja8pnmatzy2wy9mpnfpru7l4hw 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1523ck98p02q4fv7ua5hurl5aehk8az8x77l6h9 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury153k8gt4zxevw2ny4sl2y6vn3ynhne5flmzlkxt 59375306227ufury,1000000000umer
$BINARY add-genesis-account fury156syqzhxd5n2fevmgnng20744h6pya57fgjnwz 4355866667ufury,1000000000umer
$BINARY add-genesis-account fury156w0r4a9z57tpmccvg0u30jn4yjzk2y7rjzwh7 1686158265ufury,1000000000umer
$BINARY add-genesis-account fury157qy8mxfz0pnxf3eervhmylryn6rmxh6vc3tlk 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury158suf8hzjsznn8f88wwtp9t9rz70dx3dzjkflw 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury15aqecutayr7gye4pyqvgjg05vj6m7cfrjdm78f 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury15e67hkf638wvskyg4j7cszsreadmw0rd7vgqyj 13635964712ufury,1000000000umer
$BINARY add-genesis-account fury15gd548sc0k8vfnzlpwpkh4hcujlynrufrhtgmr 2002342301ufury,1000000000umer
$BINARY add-genesis-account fury15ksf0l4qy94km7auqaeczjtty82hfhx99785ac 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury15m6a2uh5v6yz9aqjqu4uxsn8trx4m6rz35f665 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury15nqkjykh6dlth0vj500emxg60ycm2k89c9lu74 1632391779ufury,1000000000umer
$BINARY add-genesis-account fury15p596785z4c4jd25828em2n8dlqjygz936l5js 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury15rhlh7x58fzz9gqay7dtpdhm0ans60u0tf43mw 7872966259ufury,1000000000umer
$BINARY add-genesis-account fury15sgem28w0ee2xejzz5x4fynv8g7wd39d9xhcp0 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury15u5djldpjsnpcz45h73fv4s78euuedmew0xnv7 1408598763ufury,1000000000umer
$BINARY add-genesis-account fury15w3gw7kxqwwurrn83ym0jgqjhu6nzcrm7degvm 2928047080ufury,1000000000umer
$BINARY add-genesis-account fury15wlj6m9eu8mfe8krftky85cka0ynfkz697t3y8 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury15xwsmwc0elma7g45pmy7gy87u72cp8nmlgru43 3366463751ufury,1000000000umer
$BINARY add-genesis-account fury15zm96pm0m9cy6zakeer8gdqy3axyvffxs84d5k 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury15zsg9p43auz79d2lv2ed9sya30hmag0qvtjpf2 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury160zup0s4p88qahlxuz7hjdf9wg4ns42ptg029y 1941333333ufury,1000000000umer
$BINARY add-genesis-account fury163w2e6et7ppcpt5wua9l3pcnjw6hl683fq7392 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury165eq9hsghfc88mf4k6lt8wk3k47v5tx8rrv6c5 19413333333ufury,1000000000umer
$BINARY add-genesis-account fury166cjg7fgj7mack7v3vfp4sx6dfl6nn7n53vlu9 2862869715ufury,1000000000umer
$BINARY add-genesis-account fury166p2ykrm84a222mnjf6uwuyqnhmh0njftdj9f9 5945813359ufury,1000000000umer
$BINARY add-genesis-account fury167g48dep9kv8ucf58fq6xfkmc5ey9dfnxvdxea 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury16ccf54f4fmgxzqay8gpmra9dzf40l2axp5g7ag 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury16gdvel8yeuj50xyhlnj47aj5t004uvd49prp30 3535250118ufury,1000000000umer
$BINARY add-genesis-account fury16gkrf094rtq6r3v76ucq4m3ncta9gfnhfkygk4 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury16jx4nh4n484kdlrjnk7005x79ylhad3xwlmdu0 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury16kzmmpway0pnz5yw94kd5ku2fjl3d5gwaftesg 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury16pn2rh0nfeuecccfk0l0nwul4hl36zuk0fmntf 5255763681ufury,1000000000umer
$BINARY add-genesis-account fury16pt0ep8jfnsu0y8aq6yw99wc3dh5s9nm8jttsx 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury16rk0wue5jxyjlhpp76epve8sjlxa92plawlw9p 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury16ssu5qp0t25czfp5sky7mmuaka5pxgfy06hthw 14560000000ufury,1000000000umer
$BINARY add-genesis-account fury16tswwwvj402r5edyrsg7c9mz0dlvfrypqfhmkw 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury16vx0lmcf22kv62hkjn7sfe4d7yy59fdte8ankz 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury16wwq6k4v6jlrjwuplwygeq9p744ynd90hahx5e 5141360158ufury,1000000000umer
$BINARY add-genesis-account fury16y53jvm0gg40gng83w34avfh69369nsxqwmrf4 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury172fmte8sj0wyat8p4qrky3n9fghmqd4df0nxl8 3111918040ufury,1000000000umer
$BINARY add-genesis-account fury174fzaef3jpvnh2y82vpnst7wjwkg8ma0yweuvy 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury175qdpq6ymj0xx68zst27cu3yhwkan9fv78t28j 1456000000ufury,1000000000umer
$BINARY add-genesis-account fury176c7z3gxwnydcpp76r3jyef6gpmx9gug05cehq 1941333333ufury,1000000000umer
$BINARY add-genesis-account fury1774tc3n4sw8y57fs6lpnxd0e4umnyps3rhncus 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury177scyy7z2a2ncs9ev5l5zsxsqp2tqvfq35z8yf 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury178pyr0m62nn7467wtsqsjgvtdnejuwdgspfcdt 1377886899ufury,1000000000umer
$BINARY add-genesis-account fury178skjzpsqa2gaepzkp7tc40m3q46ua0uv4jrzg 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury17a7002v839lkwdxvjrxqfk80s2n6qje2ldfvqr 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury17d0zehlqepqdn74vwlqtkc0z225rsqknrqq8jw 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury17dafzd5htnkt2gk0g2emwx9zyarygm90fry2p7 1334666667ufury,1000000000umer
$BINARY add-genesis-account fury17er7xt02cjv0f308q3rfeeqf7vteus36advdlw 2817724060ufury,1000000000umer
$BINARY add-genesis-account fury17f3e8gzl446eyf02ux3fdph67dtlx8up2nam0c 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury17g0zdv3jmve0rsx6rmcr5vhg0zdg0vhd9nttx8 6855333333ufury,1000000000umer
$BINARY add-genesis-account fury17hw7yx7vkhmueftc7anqz84p8k4ly3fx8actyp 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury17ljajuptdn3tjvm2g2k8s5cnc7cxen539lngwf 2438800000ufury,1000000000umer
$BINARY add-genesis-account fury17mewlwfuymfygx8r7kanv6lukvz50pvv928635 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury17nrcyla9azxyuk74yksvehff50tzu87a8mwm7d 9100000000ufury,1000000000umer
$BINARY add-genesis-account fury17pnt32uz8c48a5jgwt3xq7tdjdayvlytuhtge3 2309689174ufury,1000000000umer
$BINARY add-genesis-account fury17uvshnyky0h5lrf05kj2w5kfy9m6lvu9jwgupc 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury17wcm0tjyhh4ymkc8fh90hhuczyq2ddu45m2k0p 4323685717ufury,1000000000umer
$BINARY add-genesis-account fury17z8cg2678wmw4zrcfa6cz5rc8vmf5uf4d6ncvv 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury17z8l64j3lr6mxrn6ltwgtxu2dxcswj2nq3wm0w 6693747667ufury,1000000000umer
$BINARY add-genesis-account fury17zznsshqhc40h0gkeaulpgwl9czxzp5vrdwuju 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury182akcm2fl4sl93v067c5akhzlq94z2423jxy0t 3782018719ufury,1000000000umer
$BINARY add-genesis-account fury182hrxr5rtr85c32zkwythz84g8rt05r7cpjury 1492400000ufury,1000000000umer
$BINARY add-genesis-account fury185dpyem0z76j07ewlpsuysdeks2gdwrlcf63mh 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1875lzd85yfn67frg0lptfnj8z5g7pmp0uyfn6g 17957333333ufury,1000000000umer
$BINARY add-genesis-account fury187eh99t2zl8fssnjrav08zwpxg0d2xfj40kxzd 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury18ava2sulw4yap2uywrvt37whzghvnm7spra0px 3759113492ufury,1000000000umer
$BINARY add-genesis-account fury18cqee39gu7mwvxuu9e7rsny4lym5c7hq376hv0 2367888371ufury,1000000000umer
$BINARY add-genesis-account fury18dc0shnv6nqnvw2zsl2xcjym56zzat60fflqd5 9706666667ufury,1000000000umer
$BINARY add-genesis-account fury18dkk2puyqm6futg6s8amz9mx5hdtwr6c79449k 3328964695ufury,1000000000umer
$BINARY add-genesis-account fury18fz823kh3ddfjtzwfcpvd3ycsq9ur3f4m8ewln 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury18g8h98p7gwz2ucj8gqyw3usutj4k5m0kmkf8nx 1456000000ufury,1000000000umer
$BINARY add-genesis-account fury18gdccgrp74hmz9uxjy5cjgqgsv6uz9r06kl7u8 6430666667ufury,1000000000umer
$BINARY add-genesis-account fury18j959yk9yl2ecfypv3v5f7s7wep3sz5ugjhdun 2360621929ufury,1000000000umer
$BINARY add-genesis-account fury18nul05mspgqfpg4pttt2rrdmnduj00qmwmeugr 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury18nxhzmg6733r93wes7d75udfmdhr9uzeeew6jz 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury18pd0ls6n6rf6hh9e37vpc3hkdev4mpzmyc4tf6 2305333333ufury,1000000000umer
$BINARY add-genesis-account fury18r43lt4njemjeyjw0s9hjfnmyk7es64rr0zf4u 3397333333ufury,1000000000umer
$BINARY add-genesis-account fury18rwg4ljlsjdcpjv82luas7pnq6jtjjcueanp2m 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury18s8lsl2xde99r9purel3ccj09tut436xvx0a60 3583698899ufury,1000000000umer
$BINARY add-genesis-account fury18smg5jgtplvn9fkahre99ux7sh6wzapc978ufl 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury18t39wg5z59sjpqeaqp93jvqakl5036hxzsa759 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury18tuxlxerqt27fz8syuqe7av9533uv85ez0qs8e 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury18wlha93wzel5rre4xfxejv9dy2gqrkc5pdwx44 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury192xfm5hy996ttccsal35jvy6tga34t3zcp9r6p 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury193e3f293kfl2ydvs9jkl8uek48z082ecepc40h 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury194jgsyqf2fmdtm5c4gustvxp0we0l8ceppxcsp 3882666667ufury,1000000000umer
$BINARY add-genesis-account fury194w5gqvt89p5s0nphyktwmuchuey4a0ea0u3c8 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1957ku9c878pyfcxxv4qmxugznsndk73fljsh0t 6673333333ufury,1000000000umer
$BINARY add-genesis-account fury19770p7rrnvxdpx02lcnqpmc4qexyr56ammrv0n 6673333333ufury,1000000000umer
$BINARY add-genesis-account fury197a7ju2g70fdltvphm70uzjpzwcfhun9wf3ar0 5460000000ufury,1000000000umer
$BINARY add-genesis-account fury197q7e78l9x2ewx28c9zd3u96yzg5uy2rfwjf68 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury19ctx5evytphdw0hcyur99xzy9gkh5803fqjggp 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury19e595g8lsvnyfsfyk4kzagxmurkuhhsyayzgry 5901516176ufury,1000000000umer
$BINARY add-genesis-account fury19ee3p09swmk03dcmrd05lldx5e53smvt3ashjt 3162413056ufury,1000000000umer
$BINARY add-genesis-account fury19erdfa2ygetc4njjyhc2y9dep5srmyxepa9dp8 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury19klvr7kjchfkp3jy0uz0apmgw7kjgw332txgfn 1484695561ufury,1000000000umer
$BINARY add-genesis-account fury19mu2wuyavmzegks0qqw5u8z2ndyqf0gkg9mdal 34617127205ufury,1000000000umer
$BINARY add-genesis-account fury19mvcts54cj799tc4qm5l3u5mt8fzg5vqsmfpxl 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury19n66dr985gy7hfh5rfjtkfwwlcly6z6rqvc67n 6106548933ufury,1000000000umer
$BINARY add-genesis-account fury19s8cwwgf9fhjw7e7k4h837fapaxytpe9g2j0e0 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury19x8cw35dvsa473nq9uevgy0n9pjqe8mlhksg5j 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury19x9fm625wr0aalhjhmlpnqjht35fkkayx6ujre 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury19y0q4qje9807nlpypemucls2vxd2jtl89mawnm 8516658174ufury,1000000000umer
$BINARY add-genesis-account fury1a0c73q0mcz6uwkwj2xhxgl3gkwscdh7v4tujs6 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1a4lqm33ex5qhdmtn5gn5uecafdr5jkxsp6nhn3 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1a7w9t33340nwc5usk29ul6tauy9wvsh5d9w4yc 1649777981ufury,1000000000umer
$BINARY add-genesis-account fury1acy8zr3c0f6yp6j60engr3pzcg5tuw6t08aesj 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1adxwvj8fpxje5v77w609hqqzgvnc6dk34whmyk 13346666667ufury,1000000000umer
$BINARY add-genesis-account fury1aezfq6kczc68dlfdgdqt02w72us85lfwn9r9j5 2438800000ufury,1000000000umer
$BINARY add-genesis-account fury1akzl5f2y5kz5qmrwx82dpy6rsemw7es9uf2r0e 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1ap2xqvx5d25k2y695d6vljnjxnz362rrw0ljvq 18200000000ufury,1000000000umer
$BINARY add-genesis-account fury1aqquex9pvzxeltv43v9qgf2n88jk4tjs4607gy 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1ar3jflttt6vsrgnn2cgyqajex5arqnha2eq443 3336666667ufury,1000000000umer
$BINARY add-genesis-account fury1arptc0q8t88ad25rdghvtewxzrrjewqaujx5ep 3506533333ufury,1000000000umer
$BINARY add-genesis-account fury1as3ttyz453cv42mxtqxrk7cuclg9y59pgd34xs 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1asga036x88ccq8rumdzujdzacz2htdm9axu2c9 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1avhku5909ay85ywfe2dq954kkqlz6w0mxpfjq8 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1aw9vyr9853v7sr9wg2934auqffccw7mvsuwdq4 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1axaqf3ggm52rc30jnphymtgau5gfyj8re9cmz7 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1axdm6a6m7r07q70c5wtvqwtu6m92f5660wrqyf 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1c2605e5cfz7gswljn597guk6gwuerayzagc7dc 5538280603ufury,1000000000umer
$BINARY add-genesis-account fury1c2nt4y0r3nqnwyqrezkhlf263d4vul2fxr9wja 14560000000ufury,1000000000umer
$BINARY add-genesis-account fury1c5mupa5ghu33u4ckjh3usm84528n7wlky4s6d4 9563656351ufury,1000000000umer
$BINARY add-genesis-account fury1c9m8lku5lzaha5mrrkwgrdh8nllwswndlyly6v 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury1c9tlevq57dyfzuuq3zp2n6gr8evpmpzx0raqcn 24279736821ufury,1000000000umer
$BINARY add-genesis-account fury1c9xne5sqg5ud5grkgt54hyjd7rky5ya8tq7cz9 24266666667ufury,1000000000umer
$BINARY add-genesis-account fury1cahaxusejsjtmmy9np775e4v43zlynausq0x85 3879212891ufury,1000000000umer
$BINARY add-genesis-account fury1cdjju75qfjq03wxg2stxc0fplzhfw2dmcs4w4k 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1ce7mdxujdc78w4y8a5tg3duhnwwcr8zp8xmrwt 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1chqk68ck9wxarrjeusu44dpmqjm0m7z5k4mk6t 1225466667ufury,1000000000umer
$BINARY add-genesis-account fury1ckgk9c9yu8j0mvrmezh2lfyal0elfcw6q707z5 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1cknhng7nqlpwpmtvr046ndfnxcdqhu65pua2t9 2520241449ufury,1000000000umer
$BINARY add-genesis-account fury1cml5mmsdh674943psrlvsxva3qxrc4qah05yq7 60666666667ufury,1000000000umer
$BINARY add-genesis-account fury1cn70sru5ut70rgr8trq9q7kjqtkcuefs7x38q4 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1cp2w03kp57fscda3sq46ln6asu7ln9g8aphyxv 23053333333ufury,1000000000umer
$BINARY add-genesis-account fury1cp86rcpjnacv6q28spzzg4u22u84d3z54d4fnt 2435422743ufury,1000000000umer
$BINARY add-genesis-account fury1cqz4rdppn0u36dka74dmwnptjmyx6j5qa5qzdg 3433733333ufury,1000000000umer
$BINARY add-genesis-account fury1cr8pc6r6qv5pjuqwxrt9cw32vxtdkg0z8tcwz5 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1crgqwm3rnfrtxzqss04ne7j7zjudx8309h2rfd 2244666667ufury,1000000000umer
$BINARY add-genesis-account fury1d25uw3a95axn0nerlsk74sdmxxwcxl964zqux6 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1d362ew2f30lu9yh0vdg65jf9drz03ueq4ftctv 1456000000ufury,1000000000umer
$BINARY add-genesis-account fury1d3g6gqsua9ac0lg86kdzsj0nal8rm0sg7wq4wf 15166666667ufury,1000000000umer
$BINARY add-genesis-account fury1d3xremqe0pqpg8295pk9w0nql7l54ttnl6plf9 4452807318ufury,1000000000umer
$BINARY add-genesis-account fury1d6dxd8u22fxjxldfqt5ek94j89m5tn2ft9qykg 1334666667ufury,1000000000umer
$BINARY add-genesis-account fury1d6uha2sc48yqyjk3nwx6vhgzgkfdzew03c9q0e 1672666175ufury,1000000000umer
$BINARY add-genesis-account fury1d7fvc0rl0ru8aa4xft4m0hg349srrmgrlhtxc3 23533476943ufury,1000000000umer
$BINARY add-genesis-account fury1d8ke6avwyjzwkrpj6wa9rjl7af37c4n7z23f6k 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1d9ejykp00p2e27gcx3w7snyy49q2c2saxjcgt6 3950427787ufury,1000000000umer
$BINARY add-genesis-account fury1dc4rlm6fc0af5kr958utzxmtzk56ek5f5y7m58 3792948312ufury,1000000000umer
$BINARY add-genesis-account fury1dc68fsdg660l33hc9ep2jmvglwk6r00dcvu6dn 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1dfgpcdyyez9sfx7n5mmfzyq0d24vy8j3cg8ycc 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1dg66744llzxj66kns76usk6wtg2y27wyuqqn5x 12204077716ufury,1000000000umer
$BINARY add-genesis-account fury1dj2w3k53025l3clq2hmhummakwlawz8c0gywew 1769014634ufury,1000000000umer
$BINARY add-genesis-account fury1dnnj0hy4wqtnhulzj69ld2ua8jah0equ0lzwa8 10011574961ufury,1000000000umer
$BINARY add-genesis-account fury1dnvk5acv55297zh383lg4r64tmluy6qyau829y 8857333333ufury,1000000000umer
$BINARY add-genesis-account fury1drqj2cf0qsn3c8l7emw0twevr766mwwc9pxwe2 6056977773ufury,1000000000umer
$BINARY add-genesis-account fury1dtv70mx9k0z93xy7rytyjp9s69df30ck7eudqk 24295628933ufury,1000000000umer
$BINARY add-genesis-account fury1dvaxrc9ur2809r9uvrtcdykk2kmlelvrnatdrn 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1dvvwtgzuqeqww77wej3k4kuh54rehj089hymlu 14278592128ufury,1000000000umer
$BINARY add-genesis-account fury1dvzxddc8t5a54q07zzn9y36h7u227tlceh86p9 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1dyh999cuqjkhadpfhh878sar73mrzy65v28772 15416306633ufury,1000000000umer
$BINARY add-genesis-account fury1dyu2rvykn5wkhp2jwa90a9fkqwk88z62dex3zx 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1dz9y79wkt0kke7cdvysen7vylg4503l23nyjqm 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1dztarn53lqte2r7fyrqx07wt9csqhs2y6zda3j 4368000000ufury,1000000000umer
$BINARY add-genesis-account fury1e24uxcuy9k4el4w24vc7tv3mmkd06wpk3v4u07 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1e3r0eezgjsfkk0pwlyhr4rlaz5n8yfp8kwq0ew 62237788522ufury,1000000000umer
$BINARY add-genesis-account fury1e3y3vj0jvk2dp0j5g7s8vk3syml6cxw3gzvzkq 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1e4wllzq9sh6sv39j5sumhvxh369lrykyzaw6tz 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1e5t4gr0xpwmqcuhrl9a2f3knck97g6d2m7f5nj 5526443723ufury,1000000000umer
$BINARY add-genesis-account fury1e697gjjauau7hhpsjpedy4xr8c5xaaee3y2rza 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1e6hk7g35v4w4x88rml30hyhsrgf3w7n50pdl0c 1334666667ufury,1000000000umer
$BINARY add-genesis-account fury1e6wrfvsvkveu0erglrnukltwa0zlkcw78qyeyq 18200000000ufury,1000000000umer
$BINARY add-genesis-account fury1e88hlawedhctya24p8gvka398mz4jr7nscpkvr 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1e9a6xnr4jnp685hwkvq9rafg0u0pjez2zl2ukx 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1edmqawpt2r8kr0seaq8tw5sy9vpdpeerl8r0fx 2305333333ufury,1000000000umer
$BINARY add-genesis-account fury1ekl0phzdgjpjjmraq5v7kgtnp0xhpk8f9j7z9y 2814933333ufury,1000000000umer
$BINARY add-genesis-account fury1eku7sqc2xwjqrfaj0v23hu98rajayrzk6ql356 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1enscws8zzejy99u02teel3x3dwxdp4v67ghxl5 5390329621ufury,1000000000umer
$BINARY add-genesis-account fury1eqf03k0vq0w6ge3qupxekpdh6axdrhaq3983zs 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1erlvaea2urcsvfw33kzfv5e6dpm9gsagjx59ef 5134527474ufury,1000000000umer
$BINARY add-genesis-account fury1eup9dxhl3xccfhc4eyddze96rzz89pja4d7nj8 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1ev6dvpetzta2x9dxydwjpkh5y89cmrwg42hv3d 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1evdyjzj7vjx8m8md7mrsrr7uh6rsdx955jta4g 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1ewfylcacwfd5cur822j3edgdz0qdxgpsqgs8ug 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1f0p979gm6evwkhz8ahw0vxvgsjs3gtf4lxucxu 2162849933ufury,1000000000umer
$BINARY add-genesis-account fury1f204cgj9v6udmehw3y60t5y0fxa9vk29p0rnl3 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1f32effdm7q3xz8gy75jud7yw0jhrkf7y25g2hn 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1f3855gmeqefp2mtt2mc7w9604nnwpzhhxc8p7z 24266666667ufury,1000000000umer
$BINARY add-genesis-account fury1f39dcuf790nly6wrzfudf2trgyc64d6wkfwyng 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1f3tcvc6n76f7zx5cdqr9dgcd6kw3td9ewzma8e 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1f66n65eywsdy5j9k05x4jgx3qdg38j9g4asg4d 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1f6tkf7na90mvweypwhm40fuggedegrrw3nmdcv 3091436476ufury,1000000000umer
$BINARY add-genesis-account fury1f9eu46p4rumakwnvl0u84tck8a8rgm4zvlfe8e 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1faqxaulwlhl36wp6jsh3zfwpz54d6y9rpruaat 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1fdhu4h867axqjtephy84z8r32w0fr4r65y5n0t 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury1fen6hz7x8wgjq0jxpy3swj7r6d36sphrxzujsf 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1fhxpt2a96m2qer7nvxuyw0c2twflq963ts7l36 6258881125ufury,1000000000umer
$BINARY add-genesis-account fury1fjl5dla43lc95d5mmx0dsgtgk6qgqc733phnsa 5772611557ufury,1000000000umer
$BINARY add-genesis-account fury1flpf5zfspa0knrq3smk7qhzjg0gay4akvljxr3 42466666667ufury,1000000000umer
$BINARY add-genesis-account fury1fn3cp92augkmugfqqd32vpf5x08d2gfcl4y3rx 3045466667ufury,1000000000umer
$BINARY add-genesis-account fury1fn5p9juy4e8sscxdf4nr8e8sk346jv97p29q99 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1fnne28kucrldwmzhcnrj3lya48f4ylrgtauvde 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1fnsz7ph3fp9exv9zcdy79ms6h5pjw53k5fxuj9 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1fqt4900qfhq6ga6jq594kpjmay02y80np7403c 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1fulqd7kt4dhg5q2maqmlrltl5gmcjdx4z4wzkn 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1fvnmel2x7v2eznvn5qmy5m5kvzm2ugl7x2ev77 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1fvp4mq8xpl2wulltzhun075hg9thrlkd2xqhrq 14108083262ufury,1000000000umer
$BINARY add-genesis-account fury1fw65tg30h9m3p0ecl2stz440840f65l9tqdaaf 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1fxxcsj9m999yry0h7u6n34p43lae8dp9ac8t5e 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury1fynl04vz5ap2pd6fus893eshuscgsddy0pgjmv 1274000000ufury,1000000000umer
$BINARY add-genesis-account fury1g3cfmqmjga9k688tmnt3h5uellxktrx899axx8 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1g70r293ravpqr3t44zzanah4a6wvzgp8mhvp97 2151386969ufury,1000000000umer
$BINARY add-genesis-account fury1g8g88vcwrt8vwtscj6874wwy8ckt4vdnnwym4t 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1g908mxj76qfumd7faaqqhf9dh8jfsxrvvqgecv 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1ga280u2wl2hargsvhkucgffrmcqsgr2ulzz366 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1ga9asdr56806aqjlrseam0s5vqswh6gr64vnfp 1750334996ufury,1000000000umer
$BINARY add-genesis-account fury1gcgxn7kefvft0hmme5n9m8fy0uq59lpewaswks 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1gctqarq5d6lcfx4kl3wdxrdvpfsuqgq0kgyjkk 5125896475ufury,1000000000umer
$BINARY add-genesis-account fury1gew69nk8zr24jm3ddkgt3kx4fgzgxwvx7qnly5 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1gfnaxe7sz9eqxmnyvnmpp6dsz5q5re36muyp03 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1ggxhuwy2cgpeup0fcnp6ky82mm9tdnq504zukx 6927134026ufury,1000000000umer
$BINARY add-genesis-account fury1ghkl6t8s237nflwsejzs9lplx6zdjpyk52hsjg 4502637117ufury,1000000000umer
$BINARY add-genesis-account fury1ghwm750fd3a5mfcka8lsscudrjxxss895feq8h 4876975872ufury,1000000000umer
$BINARY add-genesis-account fury1gkjzjsepl50js0qzmyeeskj9u45zqen66d6rm3 1334666667ufury,1000000000umer
$BINARY add-genesis-account fury1gnm63v8k870lc5n3wxndkzhcumzljx6e56yr4c 1698666667ufury,1000000000umer
$BINARY add-genesis-account fury1gpntkvgsrlnfewy72zfrdd48eahfdqlqx9s7sw 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1gu4z5h4k6umudeayggdaa7tpskcufuvxkg048g 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1gy49qugz2hxcm5su2ckr0egkctp2hrfgaj9t8d 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1h476wae7zccqaunk0qnqtspswum5h6dy8x5546 5955171346ufury,1000000000umer
$BINARY add-genesis-account fury1h4gg9xxw9jdjkqjsy5tfvnk5cs7rq0wer0dcjg 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1h4twxe0pzy32uh48ak5p3vfx5ca50yuaz6v0n4 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1h5prgtr2xlv0g22l46zkjv2zpddc3hdvumd2vl 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1h69v6zum5yx89xsght7l9qeclm54zp8ew40er6 16002303893ufury,1000000000umer
$BINARY add-genesis-account fury1h804e5mngu2h70mrz0d6nvzep38rrkfta8fye9 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1ha8nzntx80c40pel385nqa2wjeh3yp9x9svy78 2356833391ufury,1000000000umer
$BINARY add-genesis-account fury1hluy442xxl0esc4f2jfjzxlahtr0834e0z6qsh 19413333333ufury,1000000000umer
$BINARY add-genesis-account fury1hp0u6qwt290x66u694zw8tdehyxrcm5naa4fnh 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1htlcas8hk4upa7m6ygfwasu9ts39z9z3l3s8pv 10396657429ufury,1000000000umer
$BINARY add-genesis-account fury1hu3k34run2xshnfjwys48yg9235sagm8vksazr 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1huczh2rvq8qmpnczh2qp9t0kacwqtf2zsl5z23 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1hwd70mwmj8pqjflretypx6rtgm92nx3f29658y 5152367005ufury,1000000000umer
$BINARY add-genesis-account fury1hzmqhvatwrf4h3436hnhh7w6zl274yejfgz4md 2366000000ufury,1000000000umer
$BINARY add-genesis-account fury1hzqu5n7kxky7w6y5pz3mfj02uw7dafklz97tsq 2243346881ufury,1000000000umer
$BINARY add-genesis-account fury1hzsem376yhguf406dq7qj0a203a6y252gdgesz 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1j2czy6dzqm86xvq4ja3m857tzhr64fx8p03jm2 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1j79magu3k9qjt84dxphgsy4zhurszh03lkgz0a 1334666667ufury,1000000000umer
$BINARY add-genesis-account fury1j7nx2jv8nv97zu5ua7qfs3sn3qzj5ym00aqv6g 36400000000ufury,1000000000umer
$BINARY add-genesis-account fury1j8n9hzamwckxuvlrv9ydarenq4nllg4d3cleae 2842728186ufury,1000000000umer
$BINARY add-genesis-account fury1ja5elnxy9n6hs5gz9yrl3ykmrg4qkldm7ysanr 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury1ja6ehmcfp0ylvr46sevmmjwqegdgxjtysut2p7 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1jcqxwly9zq8ew6cnluzeyt7gld434sa8ltt49d 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury1jesfrtv3yjcug7c2sfhfdavh6h0yhdhs6pyrua 24266666667ufury,1000000000umer
$BINARY add-genesis-account fury1jf0rruu7xulwf926hellln44dyxr039hpst3h9 58806451461ufury,1000000000umer
$BINARY add-genesis-account fury1jg8ml4tzmsvcwwjwnm7j4xhz7md37p4u80ljf3 6006506188ufury,1000000000umer
$BINARY add-genesis-account fury1jhte7qrxz8qw0k0v6dy3sdlwgagjztp4d9h9pa 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1jj08pyzzgm9l5amrsd8yuq25n3vxh6vrmxx0pj 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1jk3xayqcts7xs5he4ml339495rxks8pgxfccs2 11562229970ufury,1000000000umer
$BINARY add-genesis-account fury1jnnrcs3tthjkftwusuwnzl5jzx86uhscmeypmd 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1jscpy49ej7awf3lcy2haxgj7c6hqj0kfrssu5w 4432908347ufury,1000000000umer
$BINARY add-genesis-account fury1jx8v3y3pfekr9v8q55mghy2kwp8gq4hdy3mxl6 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1jy43uzguhxkrlhm4m9cw48emuzatjumv3gd7mt 1565030566ufury,1000000000umer
$BINARY add-genesis-account fury1jyvntlr4d63uwuvqtnt0s6pvanntyah8zl7zyn 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1jzfe2sfzxvk9nzk9p68v3x8tehnfrnypa34a5j 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1jztmuwrtvzptucgrcehqur95sw9cr5zscq04st 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1k2r4e549wxe86xsq85e39ejhmyvssc22008c30 1880112739ufury,1000000000umer
$BINARY add-genesis-account fury1k3q9egmtyle7r6kj4d9v3855mzjfd47lcru3x9 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1k4z3yayer5vx6jlu55nanhm8839kd5mj3fylem 5772611514ufury,1000000000umer
$BINARY add-genesis-account fury1k5hvlf8rgmtkrzxew6mje6lznjae288xnqatjl 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1k5jqtxvtv8h496cyfw4j7htn3dz947sfc65n5n 3761333333ufury,1000000000umer
$BINARY add-genesis-account fury1k9pn6unxu6ak349psle9d2lcj02rcy5fa47gtz 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1k9wm026js2uunq0yj73fjg5un8t8su5jae33la 3636243803ufury,1000000000umer
$BINARY add-genesis-account fury1kepduqfaclatwzsk482dyu7rr86ly94mwzzccf 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1kfetepa5p99l9wmpdmgrz4gn2057kupexwlz9z 11441085237ufury,1000000000umer
$BINARY add-genesis-account fury1kkv9vl2jpy2rn34wszzn0gtcg6vtwr6yzwvag4 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1kkwnj02f4cakh6mxjfnwxsxj0s3zfgr7nqyj35 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1klf86a635j7lcxr567s4hdt4xlfcqz7mz70atf 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1klfc4aguw0gjmqkfd5l4s3aaps5658f3rwc00j 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1knjckkk4mjxrwey8mumgz3krpl27j9gym7vrv6 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1kny7u2xvm9c5mu8wulg2ta25z9k8lyw3d8tzf6 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1kp8fzp5arw6yrxcyy7qp60027ksspnnlv8zklx 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1kpf2a33kct344v0e004r4dlmcpclxn826rg44x 18200000000ufury,1000000000umer
$BINARY add-genesis-account fury1ks6v4t2xgdzwtfu5jahfk5z0xjcazxdlk7yjap 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1ks8qnyyprnjt9alxk9j98hm60a4522jrphejaf 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1l02jjspsha5qumlthdhvkpy8r8ny87536t8zp2 5860042704ufury,1000000000umer
$BINARY add-genesis-account fury1l2arwm499kxuge5klssmf9ftwe6fz7cy47wjd2 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1l4kd9w2y8ykryepl8uf52x0gwxh5v9aahaegap 8493333333ufury,1000000000umer
$BINARY add-genesis-account fury1l5ueft9awlf4kvdewpxykkscmqa0t7ycetd4yc 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1l62yvvjhnlh9gjluutf8zmcaxnn6qmpj7xefce 4342296332ufury,1000000000umer
$BINARY add-genesis-account fury1l6c028e3sy9wsw9rn48zqtaz6nspx5mz96jjtt 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1l6nwemu5lz9hl9nsnthyt0ptqyddj0vkaqv30x 12413761675ufury,1000000000umer
$BINARY add-genesis-account fury1l775z2yeyp65drp0ypkguw3ymggav7px4ras54 1368980168ufury,1000000000umer
$BINARY add-genesis-account fury1l7n5uhhltcx0hcu0grqdcnpr6lc422txuv390u 9349994599ufury,1000000000umer
$BINARY add-genesis-account fury1l8ap4vgfw2kcg6q6a50d03k8xz5kcysw23keus 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1l8lsmhtkgl04s0z6x6r98henuadv2egue7ydg6 5268186476ufury,1000000000umer
$BINARY add-genesis-account fury1l9y8auwnhr7lut8gtc6lpug7m5q82rcaum8txs 8658917085ufury,1000000000umer
$BINARY add-genesis-account fury1ldcmx4s6z75fnmrp8zlz9qfskshyppkhv37hca 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1ldmkv743yqlvz2ztkwk5axdjygecq25u3lnmlx 1844266667ufury,1000000000umer
$BINARY add-genesis-account fury1lj9qnd07tl698h24qu26epl8yxh3mr38n7mf7a 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1ljd9udnm89sw2tpp0q4n9nu292ztrj8js6kyp8 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1ljqy2yr85ksmhhn05tp32kxzvl3dprz3w2dcs3 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1ll7g0gny3r5jhsctxf7q83rjnk20vyd6ug62ja 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1lmwmfsvwkac02ea0zvv2gtmpuhwq7jhk57j3nv 22276562733ufury,1000000000umer
$BINARY add-genesis-account fury1lnf7qytuqky84hz6tncde2jm7yqru60gg3ssz6 1523292004ufury,1000000000umer
$BINARY add-genesis-account fury1lpfag8uf4cncvsu9a229a7rjt83x3nr3svx5up 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1lql8yaqrckujphjra2gcz7qvehepu69lnpjdsq 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury1lsy3g2s928mjzxaxz02epelrsmhqqf30x4xpxp 1917066667ufury,1000000000umer
$BINARY add-genesis-account fury1luqwun2d2guesalj3pxvx6wjc8je6rj6cwzr4v 1516666667ufury,1000000000umer
$BINARY add-genesis-account fury1lwdp2g8087fus85mqw3e7xgy04detnjz7kadry 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1lyareh24qmtn34ejcfxcy7s88m3ym8jtjcz348 9100000000ufury,1000000000umer
$BINARY add-genesis-account fury1m2kmjn4h07uxdrf0cx8sw5ytqg4sdutc3ptf32 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1m2m99lcdgyljvzccypch78l3f8xw5lzccya2c3 2984800000ufury,1000000000umer
$BINARY add-genesis-account fury1m4tvaj5mlermqy94sf6kudftvg6mqzy2ksw7sy 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1m5lmm5xzr084ual09u56gqhca325zzcnxrgxa7 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1m6nul2lmf3lg37nmr0cresxrpjw7dr78ks9ayl 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1m7m39v60f9qg6gvrrjt34hpx4pmkheejgnu2ve 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1m9ppm08ngt3zn6tngza89exuut9z0tmakllv7d 1225466667ufury,1000000000umer
$BINARY add-genesis-account fury1makev707d24l86jv57h46smlwyc4jelaqcv2dy 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1mcqjtjm7e60x3u4sawam9ckq6spyv3tde2q0gh 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1mf2l78hm024yvufdzp93fzrspd52h2q3c3nt5e 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1mgwdlvafnylsl23es3ca6p9dsm4nl54kuekffe 8493333333ufury,1000000000umer
$BINARY add-genesis-account fury1mjlen9lwmgcga2ecmaxcqq8a3aetgms34f6wdk 4004000000ufury,1000000000umer
$BINARY add-genesis-account fury1mkhgc2tq33n90uaa5nc4yrhgp86xy79e35cfnm 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1mku0fdwlsayy6gxg0pafvmvyfa47x9mcq5r3lf 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1mlcp7xtfvq3ukvlz750gty80yx3tf0maljr0pz 7121832700ufury,1000000000umer
$BINARY add-genesis-account fury1mmc4ptuas23wl0ektyr3z093mgk862zh0dth48 3232538764ufury,1000000000umer
$BINARY add-genesis-account fury1mptwth8gkj4u92dtn87cwf5fwg05nn37e4tf9g 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1mrzkyf8wmgrga2wypmhc2g6s9tzdpg4chrzhuj 5096000000ufury,1000000000umer
$BINARY add-genesis-account fury1msvwm60fnsqeh4qpyp3tfv9f3ua6z9gj4eyua0 3043589742ufury,1000000000umer
$BINARY add-genesis-account fury1mwtlc87t6gkjrhrqhgulq30vun8rg4z7vgz3hq 1274000000ufury,1000000000umer
$BINARY add-genesis-account fury1mwtxdmrvvmdqs782nqzu5kadtg4wkzm8hv6yh6 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1mx3lxpk9wfqvu09wv4tcemee3rappaus5jq898 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1mz7mplkghauxlec55gqf5449urddjy69pyqvjh 1505300451ufury,1000000000umer
$BINARY add-genesis-account fury1n00flv87m7m9wvl38zmrhkwkj6knm6r9w8a36s 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1n3gn6yyyw2ggghgjkrkvsn52zsrhgv7u3dnj7w 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1n3tzakd7yvnwgq44x6a2hwxr7x87fxzekqjune 5055960000ufury,1000000000umer
$BINARY add-genesis-account fury1n4nrug33xc52nkv40jaeqmv402lrrm55z79c98 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1n5apddrlqq5kzjp4pstl68earqqpddgeauarc6 18200000000ufury,1000000000umer
$BINARY add-genesis-account fury1n5k2ce4cf6xyt9vpqr30eshu47fz0yqa0ftjnm 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1n75apcsmzejuwu6qn2zath5maaw83d0sr8gfya 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1n9dh43x9l6ep64zrcqfz3w9y93patwwpw2dt3a 2184000000ufury,1000000000umer
$BINARY add-genesis-account fury1n9mak9c36cr02hnuky2rz3kd67lxrdksw59nmu 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1nc6zcagt4a5akfgtuvee7mnlprdy3tlpss5m8j 7583333333ufury,1000000000umer
$BINARY add-genesis-account fury1nch3mle8wuklypfylh75jyr4vgd9s9psqzaeue 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1nd58d0udyrql4ck4f88exxxkayvypz9ngvahzd 2123333333ufury,1000000000umer
$BINARY add-genesis-account fury1ndr0xeqeysczhny57nrq547vz89wmp7g9p7eg5 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1neq5ncmumavfjs507zjqlgz6yvfmhdjud8vkzx 1937863602ufury,1000000000umer
$BINARY add-genesis-account fury1nfzs530ejxx55cfk5x8unllaz6l2glv8ccjewr 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1njfsq77scw3u9aew7p0k3gnx02uaddheqcye5p 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1njyyp3dv2z30q7hduk2gp7hkm97x74x2ml603t 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1nkvhuhk6dp3yakv45a840hxscpsk58wq304u7z 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1nmxc7l3h9rejfygfdwlhkx292mumnv6rt82ecs 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1nn42j87g0rn5yqrfqdsdwjhfq7pz8kt343lzzx 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1np65kn0xpypg4f9rhllyqyla4syg0mmeuhfujy 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1np9jmdp30u2cvkp02shh5aj9v6jqr7epzq78zv 3518666667ufury,1000000000umer
$BINARY add-genesis-account fury1ny4qrmum0yaqvcv32cv8mz0jvu3tzzlh8ndgdm 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1nzv5za6zavxpa83gm8l7p0dnx9mlfe3fmglm5k 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1p2xpt784jn4598dkkee7v8gcnp25mmn77cvl5a 6574998430ufury,1000000000umer
$BINARY add-genesis-account fury1p3vuuewqe04hf6hh6ma0u3y0xewe34sq3nrsrm 34037783155ufury,1000000000umer
$BINARY add-genesis-account fury1p4s04677l4zvnfywawk5uxyf3akg48qkl507xs 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1p7gp55l987wzvwq9weugm3x4acxey7uvg95qmr 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1p80y89l86v8zt2nl5stdnhnswlhmpl60ctcfrn 1705589906ufury,1000000000umer
$BINARY add-genesis-account fury1p820tpnuv3h0jya9y5ju9v3l5vc27l9fhmpyar 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1p8fz82llks8qlfxfsnyhkqa5yrgn54h54td6r5 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1p8hk0ry6w0kz3xgcuj5m6rus88nycwcgct9j40 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1p8jwlmwy7k2lkvxpkpmknppcsskzlustxqym46 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1p8xsu32x34k0cgq9dvfcdpzkhv3wjemhf3z3kr 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1p92gndsjv82x8fj220paudtgtqts6kz4r26tf9 2055059107ufury,1000000000umer
$BINARY add-genesis-account fury1pa2ax82rdv2fqcsctdzwe9mlhmjsqz3r64u2ez 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1pdad8k5ra6n868hz349n650tjml4uel8h3sl2y 1240568173ufury,1000000000umer
$BINARY add-genesis-account fury1pdtutnqkxmjchegv4qzlncwzdjvgp4k4q5n83c 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1peh437hcvvqge3ekdse65a0x4m24e545n2wfs3 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1ph6q7z3ltyzn2jtxl4e8808qgcw6vrglqhm05c 5974415400ufury,1000000000umer
$BINARY add-genesis-account fury1pk8awct9kzpjmysstp2rfrvhmw2tyy4mgkvpqh 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1pkmu5cjz0vkup2wly4xhmlkstaunky5l2f9044 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1pld3p6f5hx7wmy573mrsmxva70c5tydptq5gqj 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1pmyvhevwnv8md9j3p0509vgflrv9w5h3490t8f 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1pngsu3vxxx04np8xgnf2j90uhjxrmp2r6ygvt4 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1pnrja9xugwwdp3ezgsxm27w370d45thgc44djv 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1pr5nf4sgcmu86fwqpvdjzklsn902l2fqng3t7l 18200000000ufury,1000000000umer
$BINARY add-genesis-account fury1psae9alaz0nzeaqwdneafgydumwxsdvve53ejr 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1psk25x77cdj3dy4kklufrhn9rrz9gj5cwg6f8p 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1ptrl3k5q4s3pal9u26aymfeyk9jw8nd7eqgp0u 2400121755ufury,1000000000umer
$BINARY add-genesis-account fury1pugg47rfwlj5yd0j4s5qx97nthr2c9escqdls5 4287939288ufury,1000000000umer
$BINARY add-genesis-account fury1pv9cl6m8ddhqnxl9r0m5nltxmfw2lrm9p0avu5 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1pvmpqflage0g46vpwqv4x49pdfd9dqwl4ztv4k 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1pwjf94z4swqk6lkqs75gmpujlcvhmu207gwh9w 24266666667ufury,1000000000umer
$BINARY add-genesis-account fury1pwm92g03xsgu20p5cl20ny7u778zfwdsjwzz7d 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1pwtsp03285nz9e2yahlnrhnueyw6v8tgchxh66 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1py8yvkn20yq6x7x9mf8l5m7elcqqx0xz9mjs0g 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1pzartp39ehpt3sun2y295akfzahje2flvlfx0r 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1q0vyz2pm6hhe5c8669d9uqcl9p7lkazdw4gsfh 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1q2s50ajg9r2w8snz365l3787g46045dkcvyu9j 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1q4ds0quxtqa6ewq84qctt0nveprz02dhrp3thh 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1q7wgsp76m4fyf5dtu0mqxre3r6ezmlhthsm7pf 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1q8dcnd7zl07t50ggfz83nkkxsh8rpu6ge6t0rp 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1qaju5jwaq0kmcrgv44q4zfu39c2v2e3c59pfw9 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1qchgc2d7fjwl4sxjrfmfsh2em8punqh09s70fj 1994665707ufury,1000000000umer
$BINARY add-genesis-account fury1qdzn7a2as606r0xr29tf4q0p9nyqjn5ld6gf43 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1qed8352kd2wphdtscrv30jqj4xlxexm8g62tdt 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1qee9cdnfw5matduutwjf6m6vlc8tq4fx2syc53 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1qgjywmavwajy24te4ja9kx0lpzpvvwuprkvm0z 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1qhgqt27ywyetl7qrr5d73k9u76f5l75zsthuaf 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1qhv4nqhtevm0ef7fzppkdgcptc657p0p5e5ahu 8874926485ufury,1000000000umer
$BINARY add-genesis-account fury1qjddnyzpc6fwz4mvkmgruwg0h3caa9h2j948dj 8009659421ufury,1000000000umer
$BINARY add-genesis-account fury1qk48392zt38ky8nng3a39u96y607ww03n75m7x 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1qkpd505yd073ug0u9g846h7gxe6270ajerg6wq 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1ql5fqh3stxxtr99etyxs3qlfhr7ug6cjdprw8c 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1qm2rl35muk7czjzh2wc59kkx9ml4nc0e9lfmga 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1qnfxtmlsmv6fzzg44a7zxgz7n7xrk249rmur92 5860457903ufury,1000000000umer
$BINARY add-genesis-account fury1qq9vwc6gcskt64mg378cnxv9xu6xr34rkj62w5 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1qqkmwme972le37cy0s8v7rlnfc793nc4z85402 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury1qv5aslwx2lff0w6gjs83eczsnmuw7tdlspek7s 1862700472ufury,1000000000umer
$BINARY add-genesis-account fury1qvwfte0waqgsg3znea29lgp4n2rzvj64v3d94j 4319466667ufury,1000000000umer
$BINARY add-genesis-account fury1qvxl2cd525p0fz2583jw3w7sf25ger9eltrt2v 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1qwka06v7ajn2gmp875zugsnnk2xpsqhwhkg65w 4249489053ufury,1000000000umer
$BINARY add-genesis-account fury1qwyhk5e9v9557fk86wtagcvkkkn4w57q5cxtkc 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury1qxnh2vcx40egn4v47ex63ce5vw5txqv8twgxf3 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1qxrey560aur6ah38swwpxzjqjvdj8hp3ccfpff 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1qynh8hgsp8ranmhv5904pyqap0jmtg9hzzjmue 6673333333ufury,1000000000umer
$BINARY add-genesis-account fury1r086c539nhw5t6khsjy3xe9x3s9f6l5vnv7d5f 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1r280hfp9ktcsz80x9jywmy0dck7p8j9xrhg6cf 22160940778ufury,1000000000umer
$BINARY add-genesis-account fury1r2s4yakf2pp3qzut0lm5lqk6twx8rj3j4nt8jw 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1r7fyr0a2xfaqc3ws2vfkkljmezjn38nqhdfv7r 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1r7u5pgx607trvjn4ssde9lpfnxh6fevyzgv5p8 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1r9ps3cpklzc9xfteqaspct457nzljywpk3xtfz 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1r9r2nx0w22n58tscc7y8jm62tau7h3j2n82fpr 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1rapu59acw73mxua5wac4jf979rr03m6fsxqpfp 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1ratnr3u2edmvmzk4a5cs3kvu4de5gn8g360ldt 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1rc8zsn3m5uxhj7wmds5zlf7s4h0l04ctpsmghn 1237600000ufury,1000000000umer
$BINARY add-genesis-account fury1reusdqdthepzhp4j94hlnymwpwtmwtg95yq7tg 2633944465ufury,1000000000umer
$BINARY add-genesis-account fury1rf46e7q5r5r3c6plklsnmcw9rv9ke59hkzv6lp 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1rhqrdkyrn363tyte4q0su4fqtvpasl8c82fhl3 19791442713ufury,1000000000umer
$BINARY add-genesis-account fury1rjghca89zyv5gedm70uzlynt2s08spavqpsylq 2147971757ufury,1000000000umer
$BINARY add-genesis-account fury1rjmpctzf3vj20jp5m544mh52ry8vulv0fhxhq4 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1rlcvpcgxq7r3c8ug4wss9ltv60dlj57lhcn25m 3276319863ufury,1000000000umer
$BINARY add-genesis-account fury1rlh2a3qakzf4hvxq0ky500l5h278sc5hg0s3yr 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1rljmsg3lcyqy7yxmduycf2x6r9gq3wd2rxh066 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1rm8vhy9sdswrfuxyfp8t5g40j59pmctcu5gc0d 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1rn48g5myl8yx95p0dg4f7fce0778pek3wru0g6 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1rp9cxhvv4084l4pkedkltevtjeexghkakedc6h 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1rpr8fyhheugztkswwd9qh9ffv93fv5tk9p4nww 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1rqv4rt64ue9mfx94wen94l0an20sv8c7lemc55 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1rsaxl3cfrp589xyxg3k7rwghsy755xgd3452m8 5283310328ufury,1000000000umer
$BINARY add-genesis-account fury1rujrmgu65tcwgn6qcge48h2q4npyp5jd44tsdz 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1rzzw44nynvnx5cxf5l5qjhn7d5xanzt4cgkhuk 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1s22gkwl6vp2jj6272vmdky0wfrxldp9awwyu6w 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1s2776tjnuyjc7tsy83y9ftvr3haeed9ngh7rkw 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1s3fwqw3v67ux2yq6xm2ve9caye0d25kpznmqqn 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1s4e02v9077nkl2j9wpk5u5had84p5re2uygmlk 11503442083ufury,1000000000umer
$BINARY add-genesis-account fury1s5jtjhusfrrcxqfxk6fdu99t0l0v25da5m0dzr 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1s6rlhewgefxmjpy2tzthtg8xyglekx2sqm67ta 6855333333ufury,1000000000umer
$BINARY add-genesis-account fury1s9alx5779rexhyfc2853tk4ux9fshcz80vedn9 1564495022ufury,1000000000umer
$BINARY add-genesis-account fury1s9rcx2ej66p62rhvjmzmk554hhm0ayrxn55ngl 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1saaaee08d6vegt6q0vaccd3vkxngktdx87xwk6 2045082914ufury,1000000000umer
$BINARY add-genesis-account fury1sadv8srrf8mvl59zs5z699j75x2y5mmwp3stg2 1876685764ufury,1000000000umer
$BINARY add-genesis-account fury1sapmztz032w2v2477a8a3ede6r5vcqx8tf4ykp 6916000000ufury,1000000000umer
$BINARY add-genesis-account fury1sdeerxfxaa02htzc9ha6f6jlqtkz8dxxccze9m 2123333333ufury,1000000000umer
$BINARY add-genesis-account fury1sg7agks2mvxp20ld29fvkjq74588twc220lym6 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1sl7cxeupsyyug0ys0j9g2nxcy3kxk3gw04x2du 4675453368ufury,1000000000umer
$BINARY add-genesis-account fury1sngp6gpcs6ye4hny3jufgux52fpuq56ehyve9w 6006000000ufury,1000000000umer
$BINARY add-genesis-account fury1snqt59uh8nt4sa0zfs4jxql63hqf9nawyhp88c 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1snrx583sy446705xpy52mlzjpk25adqup2ctq2 24266666667ufury,1000000000umer
$BINARY add-genesis-account fury1spfly3rl9ulrkwhec0mlg5sdlqqhmqttcx7dpa 2373961636ufury,1000000000umer
$BINARY add-genesis-account fury1srlplp95ls38t6z5qmfka283tsla3npvq54ylv 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1srt6dydwkdq8lysjsc8vldsyjv3yxmnlduxm6w 3579333333ufury,1000000000umer
$BINARY add-genesis-account fury1styf0hry6f4yr0wsy4j3ym9sd2ry70ul6lzcrx 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1su9eezuavy8g9meurwns94236en6aug8d0h5lk 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1svju9jc7jvpky3u3hs9tjms7r72jcfvnmn6gju 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1sw92748c8hqxad53fqwcm56dfaftnc46rupny4 1456000000ufury,1000000000umer
$BINARY add-genesis-account fury1swcwwfpa5rdpdfksvtarqppcdaumdeka9hxak4 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1swx5lj8u6dw95k9v3neyduvp3fx0609cl94xhe 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1sxg6zaxxghm32z0h2wrcl5k8qdfktuyx9a55p4 9706666667ufury,1000000000umer
$BINARY add-genesis-account fury1syjzyaztglua6ftgmn8rfgl4je6w4ll0dxkpaq 1577333333ufury,1000000000umer
$BINARY add-genesis-account fury1syp6ptqv7dqcf643chrm2s0cednxt68pna5c6h 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1t0mhfccsjj3yupe9t28vz8a4ac3hljunxgsw79 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1t0u835480zje7u9c3wfrqc592peuy3lk5we04d 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1t0x6qet7nhct5a2zgec033u05vcrm0sdrlq6pc 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1t6lc96y7g4crp7d642r95x9fl74xk24glpl0c5 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1t7sk2p039d427kjd7r5ecdeyrca6v88xn985ag 7886666667ufury,1000000000umer
$BINARY add-genesis-account fury1t9laym8cm58tgllufym0hx6lun0n8vwlj688hc 9155664621ufury,1000000000umer
$BINARY add-genesis-account fury1te2w67lzm5lk42earv2clxddaxy2rqm33ufkv8 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1teusq2nlq8v6jyu5lzqfw2fesaece30znvyuv8 3882666667ufury,1000000000umer
$BINARY add-genesis-account fury1tfl0qycueflu0p9tzwp5vnqz9v6d6rg3nutr0k 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1tgyluhnjm5dyh4mudkgxpsrlj0aranjpdrj9tk 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1th6xu5p2nkzvmpke2n4p66q2wkak67hq0knsad 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1thdhz34840uvlrplw2mc2pl5cj348ed0p6lkd2 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1tq5d94qrqvel89ramhpu5kuzt4vfgepqahawwa 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1tquaf0pp7pen7xguf7ymqtqglhyvtly7584z3k 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1tr703x4rka0rz4d756x97k360gm8ys2aynvz2g 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1truwaxrhnd8k93gvmp5gj4qahwadlnep5yh6s6 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury1tut0t05a0xrsz7963dlnxlxtjxs8pqp05e9t6k 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1tvct360x2trxycxzvkxqwvwaw3efkqw8x2zkcf 2123333333ufury,1000000000umer
$BINARY add-genesis-account fury1twxexaxwhu6n0na6aqj8f4t4jfx7hqfwp8hcrg 3328855796ufury,1000000000umer
$BINARY add-genesis-account fury1u47487s2eqhaxq5rndntm38dnvr999ntthj9p0 1685736494ufury,1000000000umer
$BINARY add-genesis-account fury1u4lanrdvtul3qqrnxm0vv5je2cgsjlu29nej84 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1u65au7lrgpzlgd2hwc8dkehu09sf2rwccvt7ym 1395333333ufury,1000000000umer
$BINARY add-genesis-account fury1u85lpcdzllvy528mzkmyth6gg3vv4f6munudte 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1u9rewswq462x29yxe3zc6wuvgz60xtzdcc0u7y 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1ues856elgspt5qhrzeks8jryd3a7jjyxscx0vw 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1uk2af6vg6ufs2wq56jk2h76llpag3ea4rgajl0 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1umgxs0q34vsy920f3aaccn5lwgv5x7shea992u 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1up9mgckqltthe55mvumafmtspce5lq8h50tpjy 2790666667ufury,1000000000umer
$BINARY add-genesis-account fury1uq9ak33xefsn9wquklqnx0pr25p4dhu056gd52 30333333333ufury,1000000000umer
$BINARY add-genesis-account fury1uuqt9pa9mm9wfr5n982efe7a6s5xcu0d08ec84 5702666667ufury,1000000000umer
$BINARY add-genesis-account fury1uva8psrkzzv8rhuqjaftwt969hjm0qa95xygjh 18200000000ufury,1000000000umer
$BINARY add-genesis-account fury1uw9uxh5x38unf3uqtrwqgc5ztsmypvdmygdp0y 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1ux8tz45k7aqnu6v3twake3gat8czvkev0szmhr 7658148534ufury,1000000000umer
$BINARY add-genesis-account fury1v28ektdlz68gtmzswfqhqrmh7av5suafx8jh6f 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1v5dqd8fdck68tlqveulqwctdctrcl59ymtsk29 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1v6pvy65fg5k00zqnz8dgqcr6vcaqmhawyh5lfg 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1v9d2wv76p7l3707u2c40pkgl052405kt6r878q 9100000000ufury,1000000000umer
$BINARY add-genesis-account fury1vcpqgnah4tkgrunxf7qp26dq6hn9s097eaq0tu 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1vdxnwvprr9lstw2wpgsszyzdguqyqptghu6s3r 5753087419ufury,1000000000umer
$BINARY add-genesis-account fury1vg2fsqrqpgufzlfdrdasz8p3lqhrzvaz00cz5l 5460000000ufury,1000000000umer
$BINARY add-genesis-account fury1vgmq5t2mhyt9vr2j5sj6ycqylsj7khqmrxaj2w 3131882513ufury,1000000000umer
$BINARY add-genesis-account fury1vhd2j3299y594qpq6xsj84t9af6ru4sapwums5 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1vkdkm4lvym3283yhp2pkv9puydknl4cg3kedfw 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1vmjgcvzazvqze0xy06tr6h6ls0csl94axkne49 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1vnepad2hvah8cqm6sdu4na7zzjccxd32lafpqm 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1vpwq7dqantthk0zahx807ft8rg9vdzq60jagc4 6488384563ufury,1000000000umer
$BINARY add-genesis-account fury1vqhtppdpxjcrxe9zdvkdxfw9f0n0xdg3uj0qgz 2366000000ufury,1000000000umer
$BINARY add-genesis-account fury1vtgjc3g626nh7xm205jwvxg3sha6z78auuq7kw 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1vv9844kryk05taxz8gq68r00z6qceexhk8serv 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1vwm373hz73avzlk467f42aqfk9l3v82ng2pref 1989345119ufury,1000000000umer
$BINARY add-genesis-account fury1vx2aydpcw3y7uuvs3edz3rkerxskayc2y7kcfh 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury1vx6rvstgs9kakjtzfj3yd0stz6sr4a9lqe94tn 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1w0m24n94quhn6wma0y0j5zmnwzyzycqyjtsf3g 1941333333ufury,1000000000umer
$BINARY add-genesis-account fury1w0t40wkn9a9kdutu9fpgha722ftazx6mqlzkcs 3495124043ufury,1000000000umer
$BINARY add-genesis-account fury1w0tpv3h3tqs8nn7swquea3c5x2cdv4waxr29t4 1979180925ufury,1000000000umer
$BINARY add-genesis-account fury1w2vjr5fp4pf5lczlttcp2zm6nskdzt4cj0l04u 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1w3sfqn7025hz604w30vgwvzvth8tu787m7p67p 5772611380ufury,1000000000umer
$BINARY add-genesis-account fury1w995nxqg45hnkluar45343hjy6n53nx0zyl7r4 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1w9z72qceey8me29yzmxcq9au3zjr609su9ft2u 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1wa29axadvv844tqzvstv4dysckt3eff9ncp8lt 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1wcfzudfqhc63nlz6hufut7lvt2j2per3hyq55h 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1wdyr7zyf07stj2e0l29f0yl0n3kanurn5sqdfg 2663266667ufury,1000000000umer
$BINARY add-genesis-account fury1wfpzztmx4sz3fqqlf4pfyk7qwy60qv90zz86kv 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1wj3cy0haq0fnluplwllklrarpsaqp38ghs5t9l 3458000000ufury,1000000000umer
$BINARY add-genesis-account fury1wkdlgdyjy7xqkl7xkc5uv0kd52jkyqakcrwuge 9888642758ufury,1000000000umer
$BINARY add-genesis-account fury1wkvpdke05hynvae4qn9w3rjxk7rcxhppvgsndx 4846838261ufury,1000000000umer
$BINARY add-genesis-account fury1wlljeh5l7gz9ss9fwk9a6ju0j5dnn3uwsrf8k3 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1wmhpzt0x2vlk3x88m00dvw7kawuu8w67cn2l0n 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1wmqcumn9kua9rqa3wvm7ejtpj75wekhkvc35gp 4040400000ufury,1000000000umer
$BINARY add-genesis-account fury1wnspfxz6ul2pqm2ww3xwl4d7unshv9y7lasm9a 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1wnw9qwa6uewumdzcz4qkhj3zqcm7xrepmzgyc2 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1wqe2uyzsgyg3chdqqxh4jsas52hzrnvksxtlll 1456000000ufury,1000000000umer
$BINARY add-genesis-account fury1wqrpsp89lcsk90nzksh4r2kcea6x5ykr3s4rdw 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1wtahd2qw00padgynynrutj6rfxqw2r0c75v859 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1wwfamdmxxs959cuufp20md89vtrzjhjeyrmf9g 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1wx25tnk96jjkhad9gplsrc0g2junr8tg9cmmpc 5723815574ufury,1000000000umer
$BINARY add-genesis-account fury1wyjrkw4nhrykfd9f2verj7yqepqxq8rs2dhkdg 1578866120ufury,1000000000umer
$BINARY add-genesis-account fury1x5jmxn7sxm9uktqddswpxh9gg6khne8wxrnt3g 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1x5pwqh5awpjmur6u5heda2sg62fvr2n0sjh8a2 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1xan8j5u42lawvq9y02ryz08vq4wg9zgahvl22s 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1xc23h80rs4thf47vhvscg688k34dx0vwng9nh9 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1xcvufxxel4p8ns0cpvh2yxuugy8wxha8kt3n9j 2974586685ufury,1000000000umer
$BINARY add-genesis-account fury1xdms4k3e8wpa45mk2uxf8nkr8k8lhq2ncz0lyr 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1xdx2n3u0n4tjpl24n5pus3fu4pljmqkshv7fk6 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1xephkpv237e03starwgd05a5w89zjvwyn2y078 1335210982ufury,1000000000umer
$BINARY add-genesis-account fury1xff6hzmst4gklzkmtu9x3ata54dhdu877haleh 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1xg3fwfsqw4yw57zaxhxa2rrd64kyv3t3zpx606 3372316730ufury,1000000000umer
$BINARY add-genesis-account fury1xj8ee7z8v8qtlvr4mk4a56yhjy3znmj696wd8z 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1xjhz9r93m2crchpwgya8vf5d9y2kd0h5erap6x 11545222926ufury,1000000000umer
$BINARY add-genesis-account fury1xke86c76zreafwghkws0cau3t9fzn2x9znsj2y 2621073249ufury,1000000000umer
$BINARY add-genesis-account fury1xleys3vper8vma5zdt7jhf73suhzyefkwfte2e 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1xmpzr7p0pcdwd6tgxz6jf59t0m6vwrfj9fnqz4 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1xp7stlqj45krged3n8e3s0y272wx5j5zujwpl7 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1xr0j66zkj405afu5e8jpeuanavtqy2wacgkhwa 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1xrtm0hgls73c9a3qgy9zejehzyrfs8hz7vmmwq 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1xs0j03ajcre6awx32aked7r0gvuk9fu405xu6p 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1xtsr64zaem86wh2e57az34qusd4md59keedt5e 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1xugsdfydpn730k9t335vawrqz08cfwhr7xhzud 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1xuh9l4jss6jck35vgpf8wh3h35qs835rlcdr2p 1225466667ufury,1000000000umer
$BINARY add-genesis-account fury1xut67sutj54vxkuq6y8msssdrflshjd8vndrvq 4300878163ufury,1000000000umer
$BINARY add-genesis-account fury1xutfrzt76hsf2uxx898r3xlvrmhzgpjv24xrv8 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1xyw4d4c8ythzsw3ausuv8ycsz9tjpymtyxclqt 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1y2rnyzcd98xw3e6hxzfd88vwuxtely3p3vkdzv 2487333333ufury,1000000000umer
$BINARY add-genesis-account fury1y4059q78s3ua85cje49stpyx5f7x574frusdea 6430666667ufury,1000000000umer
$BINARY add-genesis-account fury1y43d0qaaklqfth9u74c23petwjhg2prfclkep5 11982208899ufury,1000000000umer
$BINARY add-genesis-account fury1y5zd895d0talftmdpm9a3faz2tz3pl7esfe6vd 3882666667ufury,1000000000umer
$BINARY add-genesis-account fury1y6eaasv3u7pkek0czj77qa28v8h33v49g40wda 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1y945wth8wmycp0ewl95cwdppcg648xgczsr4kq 9706666667ufury,1000000000umer
$BINARY add-genesis-account fury1y9hk34pcnlemzwqsq7fa6culy3hcg2glcagl2c 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1yl0qskuag49r4e5letawrnj4wyvlkaq2gkmrpy 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1ymfy6428yyrlqzsggqk9c9nx52p3epvh270u7k 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1ymn3vucj7yuntfyk4wwnwsmfyp7nhmp9kn86qa 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1ynszh0m59gsjap438zft7ux57hq60re9aafz2n 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1ynztcwthyyyr3km6nsuu7awspsce7z6jmdl007 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1yq7anadflykv7l9jfq7wp7vnuksdgxezjv0apx 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1yr4u5pz7j8g2cl6smsm5lsajlv7gkwjgelw82e 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1yrm5g22pt203zdectl38xyk6sph77hk6x7y20x 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1yrvgf3x3namwckefr098atr3fvpvxeyen58trh 1395333333ufury,1000000000umer
$BINARY add-genesis-account fury1yv8e6dz4l9qkw8y3eztaq3p4qfznm0ujmt7qzc 13099376102ufury,1000000000umer
$BINARY add-genesis-account fury1z066lxy9ydg3ln8lq778fa77a0fkzd3l308ylk 4853333333ufury,1000000000umer
$BINARY add-genesis-account fury1z09md5n7stw880zq29g08kvynz04vmflphjfxr 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1z2jvwyrwhaqzps63la9gn4yyay75ltnmux7v9z 3640000000ufury,1000000000umer
$BINARY add-genesis-account fury1z34jtm74a4ngea3rpxusmt4sqq8rlgcucuc9yp 6066666667ufury,1000000000umer
$BINARY add-genesis-account fury1z438vq4wp8afnhz0h8flrfrx9haehlrht4n3j2 3882666667ufury,1000000000umer
$BINARY add-genesis-account fury1z4v3dhdpcsxry2hw535ddl5n9mtuugn9vl5dq6 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1z62ah8ry0lepczunvynrc8pxcj0nee7jg2ey8c 1820000000ufury,1000000000umer
$BINARY add-genesis-account fury1z6hm5y4w8h93ksa3vq0cvqwpp3m0mq8adm62kg 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1z9p7pdmxcs0e5j5k5xx2d30yy8hm23c600sxky 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1z9qgcphku88s55fe45tquju72wlu2la8ak2x9g 60666666667ufury,1000000000umer
$BINARY add-genesis-account fury1zahj9zmceehqudeae86zvklujj97ysw4lpu27l 4246666667ufury,1000000000umer
$BINARY add-genesis-account fury1zdzfa7cw33jvzp54qj3rcsplxahmhvueek3z7u 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1zepph0x9ud9c9jzqwja5qsuzvryekqz8w664ns 5901531544ufury,1000000000umer
$BINARY add-genesis-account fury1zev470vlwdfup3syyu7jn2r0dxkcd8f6k2xyg2 3033333333ufury,1000000000umer
$BINARY add-genesis-account fury1zeydux3xkdzt58s4pg84cekjm8p6seulx7tcp2 1213333333ufury,1000000000umer
$BINARY add-genesis-account fury1zgatyc2gwaeh944rgdjptyzpfadcvys30z2m7l 8604767408ufury,1000000000umer
$BINARY add-genesis-account fury1zjtjpfqmmz322tz74hm5ncw33da3wv9ut8064q 12133333333ufury,1000000000umer
$BINARY add-genesis-account fury1zkaxzladjzfxzzrulljhg76xe36kun5j77sxae 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1zlr8xu0z57dx4n8kxnf9ngfp36y3ktg0c5uzk2 7280000000ufury,1000000000umer
$BINARY add-genesis-account fury1zlw3qf52u38u7g4fg3gew00aye2w0p9dkj7ty8 10921641294ufury,1000000000umer
$BINARY add-genesis-account fury1zmf6xnu0hyvjl6cjv6tzvhd4kqfxnnlgljrelx 2426666667ufury,1000000000umer
$BINARY add-genesis-account fury1zn0j3mnfwuxd09kdv35ghmjvyzllvz4ns7m3le 1706322488ufury,1000000000umer
$BINARY add-genesis-account fury1zqxpdcmr3ylq9356clu99dnant57rvyyr2kgtl 1422091922ufury,1000000000umer
$BINARY add-genesis-account fury1zsqu60y738u0jgk36sdrptq44ejke6a707k9pz 10920000000ufury,1000000000umer
$BINARY add-genesis-account fury1zuvurmf9x4tpe3528gj0gxg9mcuxg5ftpfe7mm 1516666667ufury,1000000000umer
$BINARY add-genesis-account fury1zxjll626lrtxqlgsdapy6uw8fkzul9s5ra9pje 3395617872ufury,1000000000umer

# create blackdragon 

$BINARY add-genesis-account fury1797slhn49lfmgn42vwjh6c6nrxq7k34n503g5t 29654569863ufury,1000000000umer
$BINARY add-genesis-account fury10h7ln638jkn55h5wfk2enyszhtv3nf3hxl4ccw 28703931507ufury,1000000000umer
$BINARY add-genesis-account fury1wexz2r5g6rsphka9qqvsqsaalc4shw7hm7wtlf 54051142466ufury,1000000000umer
$BINARY add-genesis-account fury13pqlfc4wesmfwg0mh224khsy9nrek2e3pwamx2 28666189041ufury,1000000000umer
$BINARY add-genesis-account fury1gwqvuzl4xwfwaxacygqkrux4dpgsl4duf785cc 22536969863ufury,1000000000umer
$BINARY add-genesis-account fury1kusnsv5evmtujdvr2hvr5chs9aen0gwyc8g0r2 39539950685ufury,1000000000umer
$BINARY add-genesis-account fury1dkmehpuc582evv2uq70kt0jptpehu3yrp5kkn8 26788501370ufury,1000000000umer
$BINARY add-genesis-account fury122nwk3z6e4yeh4aj4xad3jmjy38h8jw8m0kpla 5931071233ufury,1000000000umer
$BINARY add-genesis-account fury14lkxkdlrmvv732vhygeev95tmerxec6arkq8hy 59309926027ufury,1000000000umer
$BINARY add-genesis-account fury13fdh9uey7t0hxvg825gdfdx346z7wsq2awsajq 287211515068ufury,1000000000umer
$BINARY add-genesis-account fury1nrye3zfvs7l438n6l56avnnzm6f00me8utjfuz 67767383562ufury,1000000000umer
$BINARY add-genesis-account fury1q97lwrj563g8ccfm6kl9zxndf860v60e8kyuey 14353145205ufury,1000000000umer
$BINARY add-genesis-account fury17mrjke5ra03hqnh7tlk265xlj2asz9lajt7h7z 39539950685ufury,1000000000umer
$BINARY add-genesis-account fury1q84cgldq5wf3am3tfuz2lzzx2azala64urfdca 39539950685ufury,1000000000umer
$BINARY add-genesis-account fury1unwqjxcwv95jfu3nt89ky8zqh39xpqvw8lnanw 14333487671ufury,1000000000umer
$BINARY add-genesis-account fury17parq8q75sr2cejrnrurtt7emfrc35a09xklfa 7100301370ufury,1000000000umer
$BINARY add-genesis-account fury199jfnv587vy4f63gn6t2t4dae42prk24lglnjg 39539950685ufury,1000000000umer
$BINARY add-genesis-account fury154sksmrrrveqcdavk4ugyxmwlmdepdg0hhthw8 39558821918ufury,1000000000umer
$BINARY add-genesis-account fury1q5cddxnk7yqxc4fjfmnpxhygkcl3uw6st5hrly 73620610959ufury,1000000000umer
$BINARY add-genesis-account fury1lw0ruyesylglsu6m7dhefw4vfh8l8qwegdtraa 9885380822ufury,1000000000umer
$BINARY add-genesis-account fury1zm3z7dd4ee8vfxu82lfmma4wmcnt3z87y4tgra 10932734247ufury,1000000000umer
$BINARY add-genesis-account fury1wackempnenwpzkywav6hnmdckqmthv30gw98am 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1cnzy6g0vet3ykdhk2xgvkvc350d3gke4aw89pv 143521230137ufury,1000000000umer
$BINARY add-genesis-account fury1r9764rmspkpy0qxx5myxq0kz90dukjnap0pgwe 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury1nk2rycxdgl5gxtd0hpncprwfp0lzeafwgeuya2 18544131507ufury,1000000000umer
$BINARY add-genesis-account fury1nhhvjlq376f4gz6jvptsgv665vr3ss4qwj43sy 29654569863ufury,1000000000umer
$BINARY add-genesis-account fury16kgjjvhq9s07l639ylpc6sfp4cp6ze8huqrp4d 7907832877ufury,1000000000umer
$BINARY add-genesis-account fury1aqqskedu4zgmjqhpztjqzd7g8sfyzya2mrgmll 29654569863ufury,1000000000umer
$BINARY add-genesis-account fury1fdgys6er5ak4syqgvc8uswcedjwknh6q6x6de6 28137008219ufury,1000000000umer
$BINARY add-genesis-account fury1e5pkymea4jlcmnzvrycc97jfhdzcvpd34sfeyy 59320147945ufury,1000000000umer
$BINARY add-genesis-account fury18rp5vnjsswdazjvrdy2lj4cass9z29h56yczv9 8799498630ufury,1000000000umer
$BINARY add-genesis-account fury1ty8uvzrhy5taa4auc9h9c02x0zfugu0ja6jqak 198251736986ufury,1000000000umer
$BINARY add-genesis-account fury1dn8yt2pe62a9nz964vmj2pwreljxehxcukkymy 197698967123ufury,1000000000umer
$BINARY add-genesis-account fury16qt98ac36dtaaxr7axu67z68ue8pjpdcx7h5pl 4962347945ufury,1000000000umer
$BINARY add-genesis-account fury1hwapfpynu0evhdvhnge6929eu0hrpj5pmt6de6 83991139726ufury,1000000000umer
$BINARY add-genesis-account fury145wnzde7ak68zm49yhgyc0apxpj6gwjejxpnpz 15923389041ufury,1000000000umer
$BINARY add-genesis-account fury12u9t55uxfmkd8c4mzpeatvnjmyvuj5gexmucrt 148851567123ufury,1000000000umer
$BINARY add-genesis-account fury1xsmep764kqh3fq4rq7yp7t3qgnjycp9lupcl2t 44757846575ufury,1000000000umer
$BINARY add-genesis-account fury16k7xarsvqf7vv0qhu520rmarpt40g6jthg7jrv 296548057534ufury,1000000000umer
$BINARY add-genesis-account fury1zejc6j533jjgzj64munsps257sa952820h270x 17990575342ufury,1000000000umer
$BINARY add-genesis-account fury1wypy5jw7xz0lkrz3ky538vr4e7seuvs94q4qf9 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury19frtd7huz6zrefnz3zl64z6q8r9wkt3pgdne7l 14366512329ufury,1000000000umer
$BINARY add-genesis-account fury1lqseqddsce3yu5wa7atf8feqqfyn3lcma03h9p 187606002740ufury,1000000000umer
$BINARY add-genesis-account fury1elhw3cct0jgxvf2tw5yrrkc6u02shg8zpr58vq 5931071233ufury,1000000000umer
$BINARY add-genesis-account fury19rn5vwga60kun3j38taxd26cm7lelgdapah08v 14453791781ufury,1000000000umer
$BINARY add-genesis-account fury1htxf0fcfmyxyw8stjw38jz2s3muh3q6y905m29 14392460274ufury,1000000000umer
$BINARY add-genesis-account fury1ymtq3eyk2s6q44phkqv8k35jqve52d0z7dxt52 19788846575ufury,1000000000umer
$BINARY add-genesis-account fury169qmwy36jkhfzjdft3ptqqmj2zgkc3tvja47cd 59309926027ufury,1000000000umer
$BINARY add-genesis-account fury1w6pktm54f5zgq032xxacc3ylme98t560wglncp 9885380822ufury,1000000000umer
$BINARY add-genesis-account fury1zjvwyksf9vnk0dwxx3n8m9xlw6pglnf0g9cga2 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1zurjhfcc5365dsy58unk6rnh9nltfsqqx8xjz3 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury134fwqahtfrg0zfr8x2su46fmrwme5mzw647qxg 12277309589ufury,1000000000umer
$BINARY add-genesis-account fury1mgmcztfm8vvmfdmtlzk3n523vqm275j7j9h5n2 16234764384ufury,1000000000umer
$BINARY add-genesis-account fury1r0afwj9krzmwsadjm6l6y7mlnq6l7px0w7xrr5 11102575342ufury,1000000000umer
$BINARY add-genesis-account fury1acd5nzld4f3c268cax90lk6he7m2w5ml64qkaw 19769189041ufury,1000000000umer
$BINARY add-genesis-account fury1lmw6wtyk0w6zg6jh05z4t5l7amvsalap5alx6k 39543095890ufury,1000000000umer
$BINARY add-genesis-account fury1wxvs6du63g8nmm5jpd3lzgwl6mqv0je9g6478l 14827284932ufury,1000000000umer
$BINARY add-genesis-account fury17zjpts3cd35tesmwrunkynygyw7fuamsg8ncgk 9390797260ufury,1000000000umer
$BINARY add-genesis-account fury1ygqgkduw25g5uezflw4gnsm4n2yvawkm33y2ry 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1zjydgdhd8uk4u29tq2e68j7kmqxrk3vsd4qnjm 14352358904ufury,1000000000umer
$BINARY add-genesis-account fury1x60g2u04z7jzdnjf3znfdcxa9ut5kufql3n6hr 397518589041ufury,1000000000umer
$BINARY add-genesis-account fury15tmdfth2kmmaedag9sk7j0nw4herj39ayu0v3r 177928991781ufury,1000000000umer
$BINARY add-genesis-account fury1r4w3ae4vuyatckn8pahvexl4kpvmndref9lfwv 7907832877ufury,1000000000umer
$BINARY add-genesis-account fury19j5upjz972gh24890tn6mpf4gzqdk09a8vjw6m 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury1cg3e7sfxkunmwgfsrqj3caju9aheuzlzmh76nx 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1ca6vj94jtn5v57prr826ncskrm0reatecv6rz7 81993934247ufury,1000000000umer
$BINARY add-genesis-account fury1ltk76ycjtz05j7ww7yznrr5cn5kz58zas0my7l 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury1y26ufq905uy0s27ftujamqm5y8gdys8dv3r3xm 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury122phsq2td9x3cv9pwszse3f69smfhhncndny3m 6919452055ufury,1000000000umer
$BINARY add-genesis-account fury1vv6rsgxqh4hyxtt6dt4rmv4a93n7amjt4j0n95 14969605479ufury,1000000000umer
$BINARY add-genesis-account fury14cyvvq5nptglnjy2hg9ky6r26349v73nfwp4qe 41516712329ufury,1000000000umer
$BINARY add-genesis-account fury1clseqnswluj79tzpng60sqhy3nf7pz0hvnuhe8 5931071233ufury,1000000000umer
$BINARY add-genesis-account fury1vvgh02zkh4qf9hydk0walw9nyx4udemrnyvmvw 24672564384ufury,1000000000umer
$BINARY add-genesis-account fury1ecm2vqdexfqy6kfpwdxxpl37vy289pmh8ya9hv 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1je5w89kn456ctj7fd3y4w4rf3f7klj6xr5s0c5 39558035616ufury,1000000000umer
$BINARY add-genesis-account fury1yuqgnfuavv2wf6lpsr0w6wqed9d7grza2675hy 42030167123ufury,1000000000umer
$BINARY add-genesis-account fury10d4udrt2md9dzeqfaytkdhcd9utsmvxk05y4cf 6919452055ufury,1000000000umer
$BINARY add-genesis-account fury108gy2rzhx27jj96argmgpesvlj9ur6k8tejz84 14335060274ufury,1000000000umer
$BINARY add-genesis-account fury1le8x5sn43nxn0sz5vuze509sea70sc6jyqj5ah 6919452055ufury,1000000000umer
$BINARY add-genesis-account fury1xvf0jjf9vkqz40rdlmm67cfhlzcwu520knk7yu 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury1tu4g3fpx9282y2ejt6zv6m9geq97mym57ln33w 10675613699ufury,1000000000umer
$BINARY add-genesis-account fury168q4t94pxq97fy8vqenc6fx3znc7p8fe9y8kxq 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1fzd65shhhkl7d3g2f5377fufd4k9adn2ph7zae 23723498630ufury,1000000000umer
$BINARY add-genesis-account fury1yafjl2890r3gn38dc7ksp5r6vnfmy8udlf4ut6 164714410959ufury,1000000000umer
$BINARY add-genesis-account fury1l52awqe7p8r9mmpm27c5avywt9urqdpd9x7qlm 6919452055ufury,1000000000umer
$BINARY add-genesis-account fury1fqtp07xjqwx2my5n42vcwufu6hc70zw4m7wlx0 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury18ws6vgl6w84qcs0wncup25va9ze88852drenza 27677808219ufury,1000000000umer
$BINARY add-genesis-account fury1vu2p0zta4lg4fsdv777ugmajyvqrcsljm56nuq 7907832877ufury,1000000000umer
$BINARY add-genesis-account fury1wltvdtjdnpe6uh5adg0m7ydy8cle8wwykfcqdd 19786487671ufury,1000000000umer
$BINARY add-genesis-account fury12m90u3cetug08frawfu0p6jd96s354xd78z4mg 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury1pm350tzyg0rvvma7e43ezz729yxa5ljukn92z7 182615347945ufury,1000000000umer
$BINARY add-genesis-account fury1pm3pva53gv4nnhvmduuh322pjmxv98t62zu8jx 19783342466ufury,1000000000umer
$BINARY add-genesis-account fury1y2l7gnylqw3yp6u52tfgxuk0klx5uymsplxknl 79079115068ufury,1000000000umer
$BINARY add-genesis-account fury1gyv42pg4j790wlqt5muge7pe9d9xdw7rmlx3rt 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1klfd2u30qakx8qeqcw0xdcc3p3djq7htt6ny3c 39090972603ufury,1000000000umer
$BINARY add-genesis-account fury145tk8ry9gzmr5jyn96pznfanadxqrvmp069rcz 28691350685ufury,1000000000umer
$BINARY add-genesis-account fury17tc5dxkejps3adusaluzu7xn9jmg7qmwffky7t 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury170k6xd7atru2uzmnqy345gyr5xcw8ke7plx6h0 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury1xe7fkxfkl882uua6zyjadv296umtxdyktwunaw 7907832877ufury,1000000000umer
$BINARY add-genesis-account fury1kxyzha73fnrzd8sf3a44dnl89whrvkdyftn23c 5931071233ufury,1000000000umer
$BINARY add-genesis-account fury14z20ghpgxayvll6ppz9m4pxp939tx2uz0p8wcj 19769975342ufury,1000000000umer
$BINARY add-genesis-account fury1cuazcgw2m3x5r9gkyusrugn50wee4t9p9h544m 10928802740ufury,1000000000umer
$BINARY add-genesis-account fury1rd4xs8xvggyrejjsemrjs9vxs4h6hdgq2y0hnt 7907832877ufury,1000000000umer
$BINARY add-genesis-account fury1ahrzs5snug646umdeeqrw6dap6ex0mntwjjwq8 5931071233ufury,1000000000umer
$BINARY add-genesis-account fury10qrkeqjjdyx7zsfdx9cszj89xjph2ctm2umzy3 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury1wa3lf2p624khztlrcz8kuh3sq8sfret20czkra 13838904110ufury,1000000000umer
$BINARY add-genesis-account fury1u7wn3x6zphmuh0yuld7jly72725d4re6expcxs 138389041096ufury,1000000000umer
$BINARY add-genesis-account fury1yrd99my556rvsfppfm96z6v7n439rr0xpe5xcm 17793213699ufury,1000000000umer
$BINARY add-genesis-account fury14lxhx09fyemu9lw46c9m9jk63cg6u8wdwgjzd6 18208380822ufury,1000000000umer
$BINARY add-genesis-account fury14c4ldwt8grnp6p9eq8kumw9uq63h8k46lfhs3a 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury1hqgete6pcc2v6zsp6kl4dr892wwgdkenyf0vns 59309926027ufury,1000000000umer
$BINARY add-genesis-account fury1fh738d3juq6zysrgu5cg52kjqt4d2z3gagg8pr 19990926027ufury,1000000000umer
$BINARY add-genesis-account fury143yykhk2r0hpj572qw4f7669hnx64r8n30j7nl 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury16wxtrzta2c9pnr3gxq7vax48kvhtw32lc9fppd 6919452055ufury,1000000000umer
$BINARY add-genesis-account fury1pzt8ykkt4puf0xef4h0xgf4watffgp405j5wrv 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury1le6qxteptv3cc29cyt2clm6zmzmn4x573unw3m 11862142466ufury,1000000000umer
$BINARY add-genesis-account fury1d727nqk2j0k8pyd7qt9s4yh7x559r04apwjjc6 4942690411ufury,1000000000umer
$BINARY add-genesis-account fury130s6vp9xk0h2fffcec0km06qp2nkdqjld70zee 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury16uru2e0ja9j9fppg7at7s0pm0en5sr3rlm22u8 39539950685ufury,1000000000umer
$BINARY add-genesis-account fury1fsezzt4rj6cm0my6z3f9hj3scvrkw5nssepqlu 5931071233ufury,1000000000umer
$BINARY add-genesis-account fury12dlda2x3fm6rqyplnk2sdemspcc9gwdjmc0hd5 9884594521ufury,1000000000umer
$BINARY add-genesis-account fury1w4v0tjfpfqrncl3mh8ezmceyjfjnnukzkau37d 10008830137ufury,1000000000umer

merlin gentx validator1 500000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1"
merlin collect-gentxs 

# update staking genesis
update_genesis '.app_state["staking"]["params"]["unbonding_time"]="1824000.000000s"'

# Replace stake with ufury
sed -in-place='' 's/stake/umer/g' $HOME/.merlin/config/genesis.json

# update crisis variable to ufury
update_genesis '.app_state["crisis"]["constant_fee"]["denom"]="umer"'

# udpate gov genesis
update_genesis '.app_state["gov"]["voting_params"]["voting_period"]="259200s"'
update_genesis '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="umer"'

# update epochs genesis
update_genesis '.app_state["epochs"]["epochs"][1]["duration"]="60s"'

# update poolincentives genesis
update_genesis '.app_state["poolincentives"]["lockable_durations"][0]="7257600s"'
update_genesis '.app_state["poolincentives"]["lockable_durations"][1]="14515200s"'
update_genesis '.app_state["poolincentives"]["lockable_durations"][2]="29030400s"'
update_genesis '.app_state["poolincentives"]["params"]["minted_denom"]="umer"'

# update incentives genesis
update_genesis '.app_state["incentives"]["lockable_durations"][0]="7257600s"'
update_genesis '.app_state["incentives"]["lockable_durations"][1]="14515200s"'
update_genesis '.app_state["incentives"]["lockable_durations"][2]="29030400s"'
update_genesis '.app_state["incentives"]["lockable_durations"][3]="58060800s"'
update_genesis '.app_state["incentives"]["params"]["distr_epoch_identifier"]="day"'

# update mint genesis
update_genesis '.app_state["mint"]["params"]["mint_denom"]="umer"'
update_genesis '.app_state["mint"]["params"]["epoch_identifier"]="day"'

# update gamm genesis
update_genesis '.app_state["gamm"]["params"]["pool_creation_fee"][0]["denom"]="umer"'



# port key (validator1 uses default ports)
# validator1 1317, 9090, 9091, 26658, 26657, 26656, 6060
# validator2 1316, 9088, 9089, 26655, 26654, 26653, 6061
# validator3 1315, 9086, 9087, 26652, 26651, 26650, 6062


# change app.toml values
VALIDATOR2_APP_TOML=$HOME/.merlin/validator2/config/app.toml
VALIDATOR3_APP_TOML=$HOME/.merlin/validator3/config/app.toml
VALIDATOR4_APP_TOML=$HOME/.merlin/validator4/config/app.toml
VALIDATOR5_APP_TOML=$HOME/.merlin/validator5/config/app.toml
VALIDATOR6_APP_TOML=$HOME/.merlin/validator6/config/app.toml
VALIDATOR7_APP_TOML=$HOME/.merlin/validator7/config/app.toml
VALIDATOR8_APP_TOML=$HOME/.merlin/validator8/config/app.toml
VALIDATOR9_APP_TOML=$HOME/.merlin/validator9/config/app.toml

# validator2
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1316|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:9070|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:9071|g' $VALIDATOR2_APP_TOML

# validator3
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1315|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:9064|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:9065|g' $VALIDATOR3_APP_TOML

# validator4
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1314|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:7050|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:7051|g' $VALIDATOR2_APP_TOML

# validator5
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1313|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:6040|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:6041|g' $VALIDATOR3_APP_TOML

# validator6
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1312|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:5030|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:5031|g' $VALIDATOR2_APP_TOML

# validator7
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1311|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:4020|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:4021|g' $VALIDATOR3_APP_TOML

# validator8
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1310|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:3010|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:3011|g' $VALIDATOR2_APP_TOML

# validator9
sed -i -E 's|tcp://0.0.0.0:1317|tcp://0.0.0.0:1319|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:2000|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:2001|g' $VALIDATOR3_APP_TOML


# change config.toml values
VALIDATOR1_CONFIG=$HOME/.merlin/config/config.toml
VALIDATOR2_CONFIG=$HOME/.merlin/validator2/config/config.toml
VALIDATOR3_CONFIG=$HOME/.merlin/validator3/config/config.toml
VALIDATOR4_CONFIG=$HOME/.merlin/validator4/config/config.toml
VALIDATOR5_CONFIG=$HOME/.merlin/validator5/config/config.toml
VALIDATOR6_CONFIG=$HOME/.merlin/validator6/config/config.toml
VALIDATOR7_CONFIG=$HOME/.merlin/validator7/config/config.toml
VALIDATOR8_CONFIG=$HOME/.merlin/validator8/config/config.toml
VALIDATOR9_CONFIG=$HOME/.merlin/validator9/config/config.toml

# validator1
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR1_CONFIG
# validator2
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26668|g' $VALIDATOR2_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26667|g' $VALIDATOR2_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26666|g' $VALIDATOR2_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26666|g' $VALIDATOR2_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR2_CONFIG
# validator3
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26678|g' $VALIDATOR3_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26677|g' $VALIDATOR3_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26676|g' $VALIDATOR3_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26676|g' $VALIDATOR3_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR3_CONFIG
# validator4
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26688|g' $VALIDATOR4_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26687|g' $VALIDATOR4_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26686|g' $VALIDATOR4_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26686|g' $VALIDATOR4_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR4_CONFIG
# validator5
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26698|g' $VALIDATOR5_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26697|g' $VALIDATOR5_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26696|g' $VALIDATOR5_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26696|g' $VALIDATOR5_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR5_CONFIG
# validator6
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26608|g' $VALIDATOR6_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26607|g' $VALIDATOR6_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26606|g' $VALIDATOR6_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26606|g' $VALIDATOR6_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR6_CONFIG
# validator7
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26618|g' $VALIDATOR7_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26617|g' $VALIDATOR7_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26616|g' $VALIDATOR7_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26616|g' $VALIDATOR7_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR7_CONFIG
# validator8
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26628|g' $VALIDATOR8_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26627|g' $VALIDATOR8_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26626|g' $VALIDATOR8_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26626|g' $VALIDATOR8_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR8_CONFIG
# validator9
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26638|g' $VALIDATOR9_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26637|g' $VALIDATOR9_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26636|g' $VALIDATOR9_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26636|g' $VALIDATOR9_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR9_CONFIG

# copy validator1 genesis file to validator2-3
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator2/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator3/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator4/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator5/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator6/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator7/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator8/config/genesis.json
cp $HOME/.merlin/config/genesis.json $HOME/.merlin/validator9/config/genesis.json

# copy tendermint node id of validator1 to persistent peers of validator2-3
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator2/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator3/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator4/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator5/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator6/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator7/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator8/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$(merlin tendermint show-node-id --home=$HOME/.merlin)@localhost:26656\"|g" $HOME/.merlin/validator9/config/config.toml


# start all nine validators
tmux new -s validator1 -d merlin start --home=$HOME/.merlin
tmux new -s validator2 -d merlin start --home=$HOME/.merlin/validator2
tmux new -s validator3 -d merlin start --home=$HOME/.merlin/validator3
tmux new -s validator4 -d merlin start --home=$HOME/.merlin/validator4
tmux new -s validator5 -d merlin start --home=$HOME/.merlin/validator5
tmux new -s validator6 -d merlin start --home=$HOME/.merlin/validator6
tmux new -s validator7 -d merlin start --home=$HOME/.merlin/validator7
tmux new -s validator8 -d merlin start --home=$HOME/.merlin/validator8
tmux new -s validator9 -d merlin start --home=$HOME/.merlin/validator9

# send ufury from first validator to other validators
echo "Waiting 7 seconds to send funds to validators 2 to 5..."
sleep 7

merlin tx bank send validator1 $(merlin keys show validator2 -a --keyring-backend=test --home=$HOME/.merlin/validator2) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer 
merlin tx bank send validator1 $(merlin keys show validator2 -a --keyring-backend=test --home=$HOME/.merlin/validator2) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer 
merlin tx bank send validator1 $(merlin keys show validator3 -a --keyring-backend=test --home=$HOME/.merlin/validator3) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator3 -a --keyring-backend=test --home=$HOME/.merlin/validator3) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator4 -a --keyring-backend=test --home=$HOME/.merlin/validator4) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator4 -a --keyring-backend=test --home=$HOME/.merlin/validator4) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator5 -a --keyring-backend=test --home=$HOME/.merlin/validator5) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator5 -a --keyring-backend=test --home=$HOME/.merlin/validator5) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator6 -a --keyring-backend=test --home=$HOME/.merlin/validator6) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator6 -a --keyring-backend=test --home=$HOME/.merlin/validator6) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator7 -a --keyring-backend=test --home=$HOME/.merlin/validator7) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator7 -a --keyring-backend=test --home=$HOME/.merlin/validator7) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator8 -a --keyring-backend=test --home=$HOME/.merlin/validator8) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator8 -a --keyring-backend=test --home=$HOME/.merlin/validator8) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator9 -a --keyring-backend=test --home=$HOME/.merlin/validator9) 100000000000ufury --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
merlin tx bank send validator1 $(merlin keys show validator9 -a --keyring-backend=test --home=$HOME/.merlin/validator9) 100000000umer --keyring-backend=test --home=$HOME/.merlin --chain-id="blackfury-1" --broadcast-mode block --node http://localhost:26657 --yes --fees 200000umer
# create second & third validator
merlin tx staking create-validator --amount=90000000000ufury --from=validator2 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator2) --moniker="validator2" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="500000000" --keyring-backend=test --home=$HOME/.merlin/validator2 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator3 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator3) --moniker="validator3" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="400000000" --keyring-backend=test --home=$HOME/.merlin/validator3 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator4 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator4) --moniker="validator4" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="500000000" --keyring-backend=test --home=$HOME/.merlin/validator4 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator5 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator5) --moniker="validator5" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="400000000" --keyring-backend=test --home=$HOME/.merlin/validator5 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator6 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator6) --moniker="validator6" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="500000000" --keyring-backend=test --home=$HOME/.merlin/validator6 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator7 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator7) --moniker="validator7" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="400000000" --keyring-backend=test --home=$HOME/.merlin/validator7 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator8 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator8) --moniker="validator8" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="500000000" --keyring-backend=test --home=$HOME/.merlin/validator8 --node http://localhost:26657 --yes --fees 200000umer
merlin tx staking create-validator --amount=90000000000ufury --from=validator9 --pubkey=$(merlin tendermint show-validator --home=$HOME/.merlin/validator9) --moniker="validator9" --chain-id="blackfury-1" --commission-rate="0.1" --commission-max-rate="0.2" --commission-max-change-rate="0.05" --min-self-delegation="400000000" --keyring-backend=test --home=$HOME/.merlin/validator9 --node http://localhost:26657 --yes --fees 200000umer

echo "All 9 Validators are up and running!"