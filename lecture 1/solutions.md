## Solutions 1

Based on my own practices and additional comments from [This Blog](https://hackmd.io/@apad0JTaSjqEjZE4TuX2vQ/r1AhU6bJO).

### Question 1

Input Command:

```bash
echo $SHELL
```

Output:

```bash
/bin/zsh
```

### Question 2

Input Command:

```bash
mkdir missing
```

### Question 3

Input Command:

```bash
man touch
```

### Question 4

Input Command:

```bash
cd missing
touch semester
```

### Question 5

Input Command:

```bash
echo '#!/bin/sh' > semester
echo 'curl --head --silent https://missing.csail.mit.edu' >> semester
```

Note here that the exclamation mark (`!`) have special meanings even in double quotes (`"`) , so `echo "#!/bin/sh" > semester` will not work properly as it produces the result `event not found: /bin/sh`.

### Question 6

```bash
./semester
```

However this would not work (as expected), which gives the result of:

```bash
zsh: permission denied: ./semester
```

We then inspect the output of `ls` for permission bits of the file:

```bash
ls -l ./semester
```

The output is:

```bash
-rw-r--r--@ 1 usrname  staff  61 24 May 10:03 ./semester
```

For details of permission bits, refer to [Unix File Permissions - NERSC Documentation](https://docs.nersc.gov/filesystems/unix-file-permissions/).

From left to right, the fields above represent:

1. set of ten permission flags
2. link count (irrelevant to this topic)
3. owner
4. associated group
5. size
6. date of last modification
7. name of file

The permission flags set from left to right are:

| Position | Meaning                                                     |
| -------- | ----------------------------------------------------------- |
| 1        | `d` if a directory, `-` if a normal file                    |
| 2, 3, 4  | read, write, execution permission for user (owner) of file  |
| 5, 6, 7  | read, write, execution permission for owner group           |
| 8, 9, 10 | read, write, execution permission for everyone else (world) |

and have the following meanings:

| Value | Meaning                                                                                                                                                                                                                                                               |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -     | Flag is not set.                                                                                                                                                                                                                                                      |
| r     | File is readable.                                                                                                                                                                                                                                                     |
| w     | File is writable. For directories, files may be created or removed.                                                                                                                                                                                                   |
| x     | File is executable. For directories, files may be listed.                                                                                                                                                                                                             |
| s     | Set group ID (sgid). For directories, files created therein will be associated with the same group as the directory, rather than default group of the user. Subdirectories created therein will not only have the same group, but will also inherit the sgid setting. |

We then look back to the output result:

```bash
-rw-r--r--@ 1 usrname  staff  61 24 May 10:03 ./semester
```

This is a normal file named `./semester`, owned by user `usrname` and associated with group `staff`. It is readable and writable by the owner, readable but not writable by all other users (either in or not in group `staff`), that is last modified on `61 24 May 10:03`.

As this user does not have execution permission, the request to execute the script is then denied as expected.

### Question 7

Input Command:

```bash
sh semester
```

Output:

```bash
HTTP/2 200 
server: GitHub.com
content-type: text/html; charset=utf-8
last-modified: Sat, 06 May 2023 11:21:52 GMT
access-control-allow-origin: *
etag: "64563850-1f86"
expires: Wed, 24 May 2023 11:31:16 GMT
cache-control: max-age=600
x-proxy-cache: MISS
x-github-request-id: 76CE:0C06:F2604A:F9C79E:646DF32C
accept-ranges: bytes
date: Wed, 24 May 2023 11:21:16 GMT
via: 1.1 varnish
age: 0
x-served-by: cache-lcy-eglc8600047-LCY
x-cache: MISS
x-cache-hits: 0
x-timer: S1684927276.196042,VS0,VE121
vary: Accept-Encoding
x-fastly-request-id: 962b756af23207139bff1f6cdc497e04807c7a6e
content-length: 8070

```

`sh semester` would create a new `sh` process which reads the executable contents and run it, in which case since we have execution permission for sh and read permission for semester, it works. On the other hand, `./semester` attempts to run the script directly but since we don't have execution permission it fails. However, if we do have the execution permission, the program loader would recognise the `shebang` (i.e., `#!`) line and run `/bin/sh` with the path of `semester` as its first argument.



Extension Reading:

[shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))
[Difference between ./ . and source](https://unix.stackexchange.com/questions/312573/what-is-the-difference-between-and-source)

### Question 8

Input Command:

```bash
man chmod
```

### Question 9

Recall that the current permission bits are `-rw-r--r--`.

There are two alternate solutions to this questions that uses two different approaches: solution 1 approaches from `absolute mode` and solution 2 approaches from `symbolic mode`. Check `man chmod` for the details and definitions of the two modes.

#### solution 1

```bash
chmod 744 semester
```

This relates to the absolute mode in `chmod` .

744 is formed by adding together the needed functionalities:

bits 1: type = file: no changes needed.

bits 2-4: we want to add execution permission for the current user, so essentially we want to change `rw-` to `rwx`. Hence we want to obtain read by owner (0400), write by owner (0200), and (for files) execution by owner (0100). Adding them together under octal gives us $400 + 200 + 100 = 700$.

bits 5-7 & 8-10: we want to have the non-current user permissions unchanged, hence we keep the setting of readable only by users associated within the same group (40) and by others (4). This gives us $40 + 4 = 44$.

Eventually we add them together to get the final absolute mode, which is $700 + 44 = 744$ (octal addition).



#### solution 2

```bash
chmod u+x semester
```

This relates to the symbolic mode in `chmod`. 

The only thing we want to change is the current user's executing permission (eventually only adding this permission and keep all other permission statuses unchanged). Therefore we only need to operate `+x` on `u` following the specified regex format.

### Question 10

```bash
./semester | grep last-modified > last-modified.txt
```

`grep` stands for `global regular expression print`, which searches for patterns in a file [if no file is provided, all files are recursively searched]. Here we use pipeline to stream the output of `semester` execution as the input stream of `grep` and then selects the `last-modified` field.



### Question 11

This question is based on DoC CSG Linux Machines (I have to ssh to lab machines as locally I run MacOS which disables me to do the question).

As lab machines are all desktop ubuntu machines, we aim to find the CPU temperature from `/sys`.

Following several trials and guides online I found out the statistics are located in `/sys/class/thermal`, separated into three different zones (`thermal_zone0, thermal_zone1, thermal_zone2`). For each of them, there are namely two relative fields inside the folder: `type` and `temp`. 

Checking the meanings of the fields online, it seems that

- the `temp` file contains the actual temperature of the zone (divide the value by 100 to get the result in Celsius degrees).

- the `type` file contains a value that signifies the zone to which the temperature corresponds.

There are three separate zones so we use the regex `thermal_zone*` to denote them.

We first fetch `type`:

```bash
cat /sys/class/thermal/thermal_zone*/type
```

this gives:

```bash
acpitz
pch_cannonlake
x86_pkg_temp
```

Then we fetch `temp`:

```bash
cat /sys/class/thermal/thermal_zone*/temp
```

this gives:

```bash
30000
37000
33000
```

Then we want to align the inputs together.

(The following contents are not covered in the lecture videos but I find them being probably quite useful. Use `man` to check for the details.)

- `paste` can concatenate the corresponding lines of the given input files.

- `column` formats its input into multiple columns.

- `sed` is the strean editor for filtering and transforming text

```bash
paste <(cat /sys/class/thermal/thermal_zone*/type) \
      <(cat /sys/class/thermal/thermal_zone*/temp) \
| column -s $'\t' -t \
| sed 's/\(.\)..$/.\1°C/'
```

Sadly this is not my original idea but is referenced from [Find Out CPU Temperature From the Command-Line | Baeldung on Linux](https://www.baeldung.com/linux/cpu-temperature).

#### notes:

- `\` denotes multiline support in command lines: when a command is too long that we have to separate it into multiple lines for better readability.

- 


