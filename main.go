package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"path/filepath"
)

func getLineCount(filepath string) (int, error) {
	var (
		err       error
		file      *os.File
		lineCount int = 0
		reader    *bufio.Reader
	)

	file, err = os.Open(filepath)
	if err != nil {
		return 0, err
	}
	defer file.Close()

	reader = bufio.NewReader(file)
	for {
		_, err = reader.ReadString('\n')

		if err != nil {
			if err == io.EOF {
				break
			}
			return 0, err
		}

		lineCount++
	}

	return lineCount, nil
}

func main() {
	var (
		err       error
		lineCount int
		total     int = 0
	)

	err = filepath.Walk(".",
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if !info.IsDir() {
				if filepath.Ext(path) == ".go" {
					lineCount, err = getLineCount(path)

					if err != nil {
						return err
					}

					total = total + lineCount
				}
			}

			return nil
		})

	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(total)
}
