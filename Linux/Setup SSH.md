# How to setup ssh keys

1. Generate a key value pair on the linux machine using this command as described [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent):
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2. Copy the key pair to your local windows machine under `C:\\Users\\<username>\\.ssh\\`
```
scp administrator@10.0.1.117:/home/administrator/.ssh/id_ed25519.pub C:\users\<username\.ssh\
scp administrator@10.0.1.117:/home/administrator/.ssh/id_ed25519 C:\users\<username>\.ssh\
```

3. Open the public key (the one that has the .pub extension) and copy the contents
4. On the linux machine create a file and add the public key contents to it:
   - locate the `.ssh` folder
    ```
    ls -al
    ```
    - go to `.ssh` folder
    ```
    cd .ssh
    ```
    - Create and `authorized_key` file
    ```
    touch authorized_keys
    nano authorized_keys
    ```
    - Paste the `id_ed25519.pub` contents into here
5. Start up `OpenSSH Authentication Agent` on the Windows machine
6. Run `ssh-add 'C:\Users\<username>\.ssh\id_ed25519'` on the windows Machine