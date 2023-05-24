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

- forgot to add `$` so failed a LOT OF TIMES for `cd $dir` while typing `cd dir` and didn't understand the error message

- forgot to add the shebang form `#!/bin/bash` before each of the shell script so that they didn't pass `shellcheck` initially.
