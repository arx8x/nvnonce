# setnonce

Set generator value in nvram on iOS


**Usage**

`setnonce` - prints the current generator value

`setnonce <generator>` to set the generator value

The input value will be validated


**Example**

Reading
```
iKrux-6:/ root# setnonce
0xffddffddffddfffa
```

Setting
```
iKrux-6:/ root# setnonce 0xff22e9aef60619e3
Success : 0xff22e9aef60619e3
```

```
iKrux-6:/ root# setnonce ff22e9aef60619e3
Success : 0xff22e9aef60619e3
```

**Errors**

```
iKrux-6:/ root# setnonce 0xdaddy
Invalid generator
```
invalid length

```
iKrux-6:/ root# setnonce 0xff22e9aef6g619e3
Generator validation failed
```
the 'g' makes it invalid

```
iKrux-6:~ mobile$ setnonce ff22e9aef60619e3
(iokit/common) general error
```
ran as mobile
