#  Password-Protected File Locker (NASM x86 - Linux)

This project is a simple **password-protected file locker** developed in **NASM Assembly (32-bit)** for Linux. It allows users to **lock and unlock files** using a predefined password, demonstrating basic file handling, I/O, and string manipulation in assembly language.

---

##  Features

- Prompt for password before accessing files
- View contents of locked text files
- Lock functionality (overwrites or creates file)
- Clean and structured terminal output
- Simple UI with menu-based navigation
- Works entirely on **Linux terminal**

---

##  Project Structure

Password-Protected-File-Locker/

├── locker.asm

├── bisma.txt

├── secret.txt

├── data.txt

├── README.

└── images/

    ├── screenshot1.png
    
    ├── screenshot2.png
    
## 📷 Screenshots
![image alt](https://github.com/user-attachments/assets/ecdd1abf-92bb-48c7-be0b-a54471a8c82f)
![image alt](https://github.com/user-attachments/assets/bc225e7f-dcc2-4fc9-b7f5-eaf21b196f6c) 

## Compilation & Execution

To compile and run the program:

nasm -f elf32 locker.asm -o locker.o

ld -m elf_1386 locker.o _o locker

./locker

## How It Works

1. The program prompts the user for a password (admin by default).

2. Upon successful login, it shows a list of available text files.

3. The user can select a file to read its contents (Unlock).

4. The user can also lock a file (overwrite/create a new one).

## Contributing

If you'd like to improve this file locker or add features (e.g., dynamic password, GUI wrapper, etc.), feel free to fork the repo and send a pull request!

## License
This project is open source and available under the MIT License.


## Author

- Developed by **Bisma**
