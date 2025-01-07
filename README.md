# br_tags

### Check the [documentation](https://documentation.brodino.net/br_tags) to get more info

TAG, you're it!  
I hate using jobs to keep track of stuff, with this system you should be able to apply any tag to any player  
the day of a single job per player are over, you can now give your users a limitless* number of tags
You can only add and remove tags from the server so it should be pretty safe (unless you know something that i don't)
#### Someday I will probably create a companion website that you can host on your server to easily manage all of your players tags (don't @me)

Feel free to make any [suggestion](https://github.com/Brodino96/br_tags/issues) or any [modification](https://github.com/Brodino96/br_tags/pulls) you want

**technically it's not limitless since you are bounded by the [limitations](https://www.atlassian.com/data/databases/understanding-strorage-sizes-for-mysql-text-data-types#:~:text=LONGTEXT%3A%204%2C294%2C967%2C295%20characters%20%2D%204%20GB) of SQL but good luck filling 4GB with a single string*

***

## Installation

### 1) Download a [release](https://github.com/Brodino96/br_tags/releases/latest) or clone the repository
```shell filename="console" showLineNumbers
git clone https://github.com/Brodino96/br_tags
```

### 2) Configure your database using the file `database.sql`

### 3) Add this line to your `server.cfg` to start the script
```shell filename="server.cfg" showLineNumbers
start br_tags
```
### 4) Enjoy!
