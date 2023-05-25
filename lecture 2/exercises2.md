# Exercise 2

From this exercise I merged the exercise file, my (corrected) version of answers and notes into a single markdown file for convenience.

## Question 1

### Description

Read [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) and write an `ls` command that lists files in the following manner:

- Includes all files, including hidden files

- Sizes are listed in human readable format (e.g. 454M instead of 454279954)

- Files are ordered by recency

- Output is colourized.

A sample output would look like this:

```bash
-rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
drwxr-xr-x   5 user group  160 Jan 14 09:53 .
-rw-r--r--   1 user group  514 Jan 14 06:42 bar
-rw-r--r--   1 user group 106M Jan 13 12:12 foo
drwx------+ 47 user group 1.5K Jan 12 18:08 ..
```

### Solution

> includes all files, including hidden files

```bash
ls -la
# -a is the option used for displaying hidden files 
# (those start with . in file name)
```

> sizes are listed in human readable format (e.g. 454M instead of 454279954)

```bash
ls -lh
# -h is equivalent to --human-readable
```

> files are ordered by recency

```bash
ls -lt
# -t: sort by time, newest first
```

> Output is colourized

```bash
ls -l --color=auto
# The LS_COLORS environment variable can change the settings.
```

Combining them together gives:

```bash
ls -laht --color=auto
```

#### Output

```bash
total 280
-rw-r--r--@  1 usrname  staff   1.3K 24 May 21:19 exercises2.md
drwxr-xr-x  17 usrname  staff   544B 24 May 20:42 .
-rw-r--r--   1 usrname  staff   8.0K 24 May 20:42 .DS_Store
-rw-r--r--   1 usrname  staff    92B 24 May 18:42 script.py
drwxr-xr-x   9 usrname  staff   288B 24 May 18:10 bar
drwxr-xr-x   9 usrname  staff   288B 24 May 18:10 foo
-rw-r--r--   1 usrname  staff     0B 24 May 18:08 aaa3
-rw-r--r--   1 usrname  staff     0B 24 May 18:08 aaa2
-rw-r--r--@  1 usrname  staff     0B 24 May 18:08 aaa1
-rw-r--r--   1 usrname  staff     0B 24 May 18:07 foo444
-rw-r--r--   1 usrname  staff     0B 24 May 18:07 foo23
-rw-r--r--   1 usrname  staff     0B 24 May 18:07 foo1
-rw-r--r--   1 usrname  staff    44B 24 May 18:01 mcd.sh
-rwxr--r--   1 usrname  staff   484B 24 May 17:56 example.sh
drwxr-xr-x@  7 usrname  staff   224B 24 May 17:56 ..
drwxr-xr-x   2 usrname  staff    64B 24 May 16:28 test
-rw-------@  1 usrname  staff   110K 17 Nov  2022 1.jpg
```

## Question 2

### Description

Write bash functions  `marco` and `polo` that do the following: Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should `cd` you back to the directory where you executed `marco`. For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`.

**marco.sh**

```bash
#!/bin/bash
marco() {
    dir=$(pwd)
    echo "in marco we are in directory $dir"
}
```

**polo.sh**

```bash
#!/bin/bash
polo() {
    echo "in polo we started in directory $(pwd)"
    cd $dir || exit
    echo "but then it takes us back to the marco directory $(pwd)"
}
```

**commands to operate**

```bash
source marco.sh
source polo.sh
# cd into marco start directory
marco
# cd into desired polo directory
polo
```

### Output:

```bash
(base) usrname@dyn3252-233 lecture 2 % source marco.sh
(base) usrname@dyn3252-233 lecture 2 % source polo.sh
(base) usrname@dyn3252-233 lecture 2 % cd ..
(base) usrname@dyn3252-233 missing semester % marco
in marco we are in directory /Users/usrname/Desktop/computing/year 1/c/40009_materials/C Tools/missing semester
(base) usrname@dyn3252-233 missing semester % cd "lecture 2"
(base) usrname@dyn3252-233 lecture 2 % cd foo
(base) usrname@dyn3252-233 foo % polo
in polo we started in directory /Users/usrname/Desktop/computing/year 1/c/40009_materials/C Tools/missing semester/lecture 2/foo
but then it takes us back to the marco directory /Users/usrname/Desktop/computing/year 1/c/40009_materials/C Tools/missing semester
```

### SP: Silly Mistakes I Made Midway:

- typing 'macro' for 'marco' // DANGEROUS!

- forgot to add `$` so failed a LOT OF TIMES for `cd $dir` while typing `cd dir` and didn't understand the error message.

- forgot to add the shebang form `#!/bin/bash` before each of the shell script so that they didn't pass `shellcheck` initially.

## Question 3

### Description

Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run. Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end. 

Bonus points if you can also report how many runs it took for the script to fail.

```bash
 #!/usr/bin/env bash

 n=$(( RANDOM % 100 ))

 if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "The error was using magic numbers"
    exit 1
 fi

 echo "Everything went according to plan"
```

In my directory, the script given above is saved as **q3material.sh**.

#### Notes on *q3material.sh*

```bash
 if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "The error was using magic numbers"
    exit 1
 fi
```

In this segment we can see a format `>&2`. I didn't particularly understand this part initially and here are some explanations I read from [[bash - What does `2>&1` mean? - Stack Overflow](https://stackoverflow.com/questions/818255/what-does-21-mean).

Basically, `>&` is the syntax to **redirect** a _stream_ to another _file descriptor_.

- 0 is stdin

- 1 is stdout

- 2 is stderr

Normally, we use `echo test > file1.txt` to redirect STDOUT to `fileOut.txt`. This is equivalent to `echo test 1> file1.txt`.

To redirect stderr to `file2.txt`, we will use command `echo test 2> file2.txt`. 

Then, if we want to redirect `stdout` to `stderr`, we can use either of the following commands:

```bash
echo test 1>&2
echo test >&2
```

To redirect `stderr` to `stdout`:

```bash
echo test 2>&1
```

Thus, in `2>&1`:

- `2>` redirects stderr to an (unspecified) file.
- `&1` redirects stderr to stdout.

Now, back to our example: `>&2 echo "The error was using magic numbers"`, this is equivalent to `1>&2 echo "The error was using magic numbers"`, which redirects `stdout` to `stderr` so the `stdout` has the same message as `stderr` which is `"The error was using magic numbers"`.

### Solutions

The given script is saved as **q3materials.sh**.

#### q3checker.sh

```bash
#!/usr/bin/env bash

count=0
# initialize counter
until [[ $? -ne 0 ]];
do
    count=$(( count + 1 ))
    ./q3material.sh > current-result.txt
done
echo "It takes $count runs for the script to fail"
cat current-result.txt
```

#### Running Commands

```bash
# in order to permit the current user to execute q3material.sh
chmod u+x q3material.sh
source q3checker.sh
# could run multiple times 
# as different random numbers generated can produce different outputs
```

### Results

```bash
(base) usrname@dyn3252-233 lecture 2 % chmod u+x q3material.sh
(base) usrname@dyn3252-233 lecture 2 % ls -l q3material.sh q3checker.sh
-rw-r--r--  1 usrname  staff  218 25 May 10:09 q3checker.sh
-rwxr--r--  1 usrname  staff  210 24 May 23:45 q3material.sh
(base) usrname@dyn3252-233 lecture 2 % source q3checker.sh
The error was using magic numbers
It takes 1 runs for the script to fail
Something went wrong
(base) usrname@dyn3252-233 lecture 2 % source q3checker.sh
The error was using magic numbers
It takes 6 runs for the script to fail
Something went wrong
(base) usrname@dyn3252-233 lecture 2 % source q3checker.sh
The error was using magic numbers
It takes 82 runs for the script to fail
Something went wrong
```

### SP: Silly Mistakes

- forgot to add the `chmod u+x q3material.sh` so the script cannot call and execute `q3material.sh` due to execution permission denied.

- putting extra spaces in variable assignment: namely `count=0`. Don't EVER EVER TRY TO ADD OR DELETE SPACES RANDOMLY!

- messed up the condition check format in bash language - namely the spaces (i.e., `[[ $? -ne 0 ]]`, in which you must add proper space before and after the first parameter). Always keep spaces between the brackets and the actual check/comparison!

- in script bash language: didn't add semicolon `;` after the definition of loop structure (i.e., `until [[ $? -ne 0 ]];`).

## Question 4

### Description

As we covered in the lecture `find`'s `-exec` can be very powerful for performing operations over the files we are searching for. However, what if we want to do something with **all** the files, like creating a zip file? As you have seen so far commands will take input from both arguments and STDIN. When piping commands, we are connecting STDOUT to STDIN, but some commands like `tar` take inputs from arguments. To bridge this disconnect ther's the [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) command which will execute a command using STDIN as arguments. For example `ls | xargs rm` will delete the files in the current directory.

Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check `-d` flag for `xargs`).

If you're on macOS, note that the default BSD `find` is different from the one included in [GNU coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands). You can use `-print0` on `find` and the `-0` flag on `xargs`. As a macOS user, you should be awarethat the command-line utilities shipped with macOS may differ from the GNU counterparts; you can install the GNU versions if you like by [using brew](https://formulae.brew.sh/formula/coreutils).

### Solutions

#### Environment Installment

With special thanks to [GitHub - piaoliangkb/missing-semester-2020: MIT: missing semester 2020. Solutions and notes. 学习笔记和部分习题答案](https://github.com/piaoliangkb/missing-semester-2020) which provides a file environment to this question.

`ex4_html.zip` zipped a directory containing the required `html` files in proper format (including nesting directory etc) to work on. I have extracted it as the directory `ex4_html`.

#### Solution

The question could be divided into the following steps:

1. recursively find all `.html` files.
   
   ```bash
   find ex4_html -name '.html' -print0 # note that -print0 is a special parameter required by the BSD, this is not required by Linux
   ```

2. fetch these files and compress via `tar`
   
   ```bash
   tar -czf q4sol.tar.gz path/to/file1/ path/to/file2
   ```

we want to import the output of step 1 as the input arguments to step 2, whilst step1 gives stdout whilst step 2 requires arguments as inputs: we will use `xargs` in order to pipe the output of step 1 as args.

Hence, the final solution would be:

```bash
find ex4_html -name '*.html' -print0 | gxargs -0 tar -czf q4sol.tar.gz
# Note that in this part, the -0 option in xargs should be modified to -d 
# -d represents --delimiter, whilst this functionality is not supported by macOS,
# you can manually download the GNU utils from brew install findutils
```

Alternate solution in GNU Linux-like format:

```bash
gfind ex4_html -name '*.html' | gxargs -d '\n' tar -czf gq4sol.tar.gz
```

#### Check Our Solution

Check the generated `tar.gz` file by extracting it into a directory called `extract` and inspect the elements and compare with `html` elements in the original `ex4_html`.

`-C` option allows us to create a new directory containing the specified files (according to `man tar` pages this is also equivalent to `--cd` and `--directory`).

hence we execute 

```bash
tar -xzf gq4sol.tar.gz --directory extract
```

and we inspect the results:

```bash
(base) usrname@dyn3252-233 lecture 2 % mkdir extract
(base) usrname@dyn3252-233 lecture 2 % tar -xzf gq4sol.tar.gz --directory extract
(base) usrname@dyn3252-233 lecture 2 % ls -R extract
ex4_html

extract/ex4_html:
folder1	folder2	folder3	folder4	folder5	folder6	folder7

extract/ex4_html/folder1:
1.html

extract/ex4_html/folder2:
2.html

extract/ex4_html/folder3:
3.html

extract/ex4_html/folder4:
4.html

extract/ex4_html/folder5:
5.html

extract/ex4_html/folder6:
6.html

extract/ex4_html/folder7:
7.html

```

#### SP: Mistakes

- Typing `'.html'` instead of `*.html`, making the command only trying to find hidden `html` files (named, of course, `.html`) -> It founds nothing, so producing an empty output.

- To be fair, using `-0` here is not so accurate but there is no way on original macOS to mimic the `--delimiter` (i.e. `-d`) behaviour as on Linux GNU. I have installed `findutils` so the g-appended commands would behave as those on normal Linux GNU (e.g. `gfind`, `gxargs`, `gtar`).

- When using `gxargs`: delimiter must be either a single character or an escape sequence starting with `\` and NO NEED TO CONNECT VIA `=` as it's already an argument part of the `-d` option.

## Question 5

### Description

_(Advanced)_ Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?

### Solution

1. find all files
   
   ```bash
   find . -type f
   ```

2. list all the files in the order of recency
   
   ```bash
   ls -lt
   ```

3. find the MOST recent element
   
   ```bash
   head -n 1
   ```

Pipeline them together gives:

```bash
find . -type f | ls -lt | head -n 2 | tail -n 1
```

Notice the change here as the first line of the `ls -lt` output is `total num` so we does not want to include that line.
