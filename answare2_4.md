# Домашнее задание к занятию «2.4. Инструменты Git»

### 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.


Выполнив команду ***git show aefea*** можно получить полную информацию о коммите начинающемся с "aefea" и там посмотреть поле commit, 
где будет записан полный хеш данного коммита (*aefead2207ef7e2aa5dc81a34aedf0cad4c32545*)


    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545 
    Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
    Date:   Thu Jun 18 10:29:58 2020 -0400

        Update CHANGELOG.md

    diff --git a/CHANGELOG.md b/CHANGELOG.md
    index 86d70e3e0d..588d807b17 100644
    --- a/CHANGELOG.md
    +++ b/CHANGELOG.md
    @@ -27,6 +27,7 @@ BUG FIXES:
     * backend/s3: Prefer AWS shared configuration over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
     * backend/s3: Prefer ECS credentials over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
     * backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://github.com/hashicorp/terraform/issues/25134))
    +* command: Fix bug with global `-v`/`-version`/`--version` flags introduced in 0.13.0beta2 [GH-25277]
     * command/0.13upgrade: Fix `0.13upgrade` usage help text to include options ([#25127](https://github.com/hashicorp/terraform/issues/25127))
     * command/0.13upgrade: Do not add source for builtin provider ([#25215](https://github.com/hashicorp/terraform/issues/25215))
     * command/apply: Fix bug which caused Terraform to silently exit on Windows when using absolute plan path ([#25233](https://github.com/hashicorp/terraform/issues/25233))

можно использовать ***git log -1 aefea***

    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
    Date:   Thu Jun 18 10:29:58 2020 -0400

        Update CHANGELOG.md

или можно выполнить команду ***git rev-parse aefea*** которая выведет на экран только полный хеш коммита

    $ git rev-parse aefea
    aefead2207ef7e2aa5dc81a34aedf0cad4c32545


### 2. Какому тегу соответствует коммит 85024d3?

Опять-таки, можно посмотреть через ***git show 85024d3***

    commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
    Author: tf-release-bot <terraform@hashicorp.com>
    Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23

    diff --git a/CHANGELOG.md b/CHANGELOG.md
    index 1a9dcd0f9b..faedc8bf4e 100644
    --- a/CHANGELOG.md
    +++ b/CHANGELOG.md
    @@ -1,4 +1,4 @@
    -## 0.12.23 (Unreleased)
    +## 0.12.23 (March 05, 2020)
     ## 0.12.22 (March 05, 2020)
 
     ENHANCEMENTS:
    diff --git a/version/version.go b/version/version.go
    index 33ac86f5dd..bcb6394d2e 100644
    --- a/version/version.go
    +++ b/version/version.go
    @@ -16,7 +16,7 @@ var Version = "0.12.23"
     // A pre-release marker for the version. If this is "" (empty string)
     // then it means that it is a final release. Otherwise, this is a pre-release
     // such as "dev" (in development), "beta", "rc1", etc.
    -var Prerelease = "dev"
    +var Prerelease = ""
 
     // SemVer is an instance of version.Version. This has the secondary
     // benefit of verifying during tests and init time that our version is a
***git log -1 85024d3***

    commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
    Author: tf-release-bot <terraform@hashicorp.com>
    Date:   Thu Mar 5 20:56:10 2020 +0000

        v0.12.23


или командами ***git tag --points-at  85024d3***, ***git describe --exact-match 85024d3***, ***git describe --tags 85024d3*** получить сам тег

    v0.12.23

### 3. Сколько родителей у коммита b8d720? Напишите их хеши.

С помощью ***git show b8d720*** и ***git log -1 b8d720*** можно увидеть сокращенные хеши родителей

    commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
    Merge: 56cd7859e0 9ea88f22fc
    Author: Chris Griggs <cgriggs@hashicorp.com>
    Date:   Tue Jan 21 17:45:48 2020 -0800

        Merge pull request #23916 from hashicorp/cgriggs01-stable
    
        [Cherrypick] community links

команды ***git log --pretty=%P -n 1 b8d720*** и ***git show -s --pretty=%P b8d720*** покажут только хеши родителей, полные

    56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

или же ***git rev-list --parents -n 1 b8d720*** выведет полный хеш данного коммита и полные хеши его родителей

    b8d720f8340221f2146e4e4870bf2ee0bc48f2d5 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

### 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

git log --pretty=oneline v0.12.23..v0.12.24 

    33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24
    b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
    3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
    6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
    5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
    06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
    d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
    4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
    dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
    225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

### 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточия перечислены аргументы).

    $ git log -S"func providerSource(" --oneline 
    8c928e8358 main: Consult local directories as potential mirrors of providers

посмотрим что функция была добавлена именно в этом коммите

    $ git show  8c928e8358
    commit 8c928e83589d90a031f811fae52a81be7153e82f
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Thu Apr 2 18:04:39 2020 -0700
    ...
    +
    +// providerSource constructs a provider source based on a combination of the
    +// CLI configuration and some default search locations. This will be the
    +// provider source used for provider installation in the "terraform init"
    +// command, unless overridden by the special -plugin-dir option.
    +func providerSource(services *disco.Disco) getproviders.Source {
    +       // We're not yet using the CLI config here because we've not implemented
    +       // yet the new configuration constructs to customize provider search
    +       // locations. That'll come later.
    +       // For now, we have a fixed set of search directories:
    +       // - The "terraform.d/plugins" directory in the current working directory,
    +       //   which we've historically documented as a place to put plugins as a
    +       //   way to include them in bundles uploaded to Terraform Cloud, where
    +       //   there has historically otherwise been no way to use custom providers.
    +       // - The "plugins" subdirectory of the CLI config search directory.
    +       //   (thats ~/.terraform.d/plugins on Unix systems, equivalents elsewhere)
    +       // - The "plugins" subdirectory of any platform-specific search paths,
    +       //   following e.g. the XDG base directory specification on Unix systems,
    +       //   Apple's guidelines on OS X, and "known folders" on Windows.
    +       //
    +       // Those directories are checked in addition to the direct upstream
    +       // registry specified in the provider's address.
    ...

### 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.

находим файл где была определена функция globalPluginDirs

    $ git grep "func globalPluginDirs"
    plugins.go:func globalPluginDirs() []string {

теперь получим все коммиты где была изменена функция globalPluginDirs

    $ git log -L :globalPluginDirs:plugins.go --no-patch --oneline 
    78b1220558 Remove config.go and update things using its aliases
    52dbf94834 keep .terraform.d/plugins for discovery
    41ab0aef7a Add missing OS_ARCH dir to global plugin paths
    66ebff90cd move some more plugin search path logic to command
    8364383c35 Push plugin discovery down into command package

для просмотра изменений функции в коммитах убираем опции --no-patch --oneline

### 7. Кто автор функции synchronizedWriters?

ищем по истории кто менял функцию 

    $ git log -p -S"func synchronizedWriters"
    commit bdfea50cc85161dea41be0fe3381fd98731ff786
    Author: James Bardin <j.bardin@gmail.com>
    Date:   Mon Nov 30 18:02:04 2020 -0500

        remove unused

    diff --git a/synchronized_writers.go b/synchronized_writers.go
    deleted file mode 100644
    index 2533d1316c..0000000000
    --- a/synchronized_writers.go
    ...
    -// synchronizedWriters takes a set of writers and returns wrappers that ensure
    -// that only one write can be outstanding at a time across the whole set.
    -func synchronizedWriters(targets ...io.Writer) []io.Writer {
    -       mutex := &sync.Mutex{}
    -       ret := make([]io.Writer, len(targets))
    -       for i, target := range targets {
    -               ret[i] = &synchronizedWriter{
    -                       Writer: target,
    -                       mutex:  mutex,
    -               }
    -       }
    -       return ret
    -}
    ...
    commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Wed May 3 16:25:41 2017 -0700

        main: synchronize writes to VT100-faker on Windows
    
        We use a third-party library "colorable" to translate VT100 color
        sequences into Windows console attribute-setting calls when Terraform is
        running on Windows.
    
        colorable is not concurrency-safe for multiple writes to the same console,
        because it writes to the console one character at a time and so two
        concurrent writers get their characters interleaved, creating unreadable
        garble.
        
        Here we wrap around it a synchronization mechanism to ensure that there
        can be only one Write call outstanding across both stderr and stdout,
        mimicking the usual behavior we expect (when stderr/stdout are a normal
        file handle) of each Write being completed atomically.

    diff --git a/synchronized_writers.go b/synchronized_writers.go
    new file mode 100644
    index 0000000000..2533d1316c
    --- /dev/null
    +++ b/synchronized_writers.go
    ...
    +// synchronizedWriters takes a set of writers and returns wrappers that ensure
    +// that only one write can be outstanding at a time across the whole set.
    +func synchronizedWriters(targets ...io.Writer) []io.Writer {
    +       mutex := &sync.Mutex{}
    +       ret := make([]io.Writer, len(targets))
    +       for i, target := range targets {
    +               ret[i] = &synchronizedWriter{
    +                       Writer: target,
    +                       mutex:  mutex,
    +               }
    +       }
    +       return ret
    +}

вывод показывает что функция была добавлена в коммите **5ac311e2a91e381e2f52234668b49ba670aa0fe5
    Author: Martin Atkins <mart@degeneration.co.uk>**

что бы убедиться что сама функция была добавлена тем же человеком выполним команду

    $ git blame synchronized_writers.go 5ac311e2a91e381e2f52234668b49ba670aa0fe5| grep synchronizedWriters
    5ac311e2a91 (Martin Atkins 2017-05-03 16:25:41 -0700 13) // synchronizedWriters takes a set of writers and returns wrappers that ensure
    5ac311e2a91 (Martin Atkins 2017-05-03 16:25:41 -0700 15) func synchronizedWriters(targets ...io.Writer) []io.Writer {

в итоге получаем что функция **synchronizedWriters** добавил **Martin Atkins 2017-05-03 16:25:41 -0700 15** в коммите **5ac311e2a91**
