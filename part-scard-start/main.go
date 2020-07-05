//  pcscd start
//  Designed By kurukurumaware

package main

import (
    "os"
    "fmt"
    "os/exec"
)

func main() {

   arguments := ""
   if len(os.Args) >=2 {
      arguments = os.Args[1]
   }

   cmd_rm := exec.Command("rm", "-rf" ,"/var/run/pcscd" )
   cmd_rm.Run()
   cmd_mkdir := exec.Command("mkdir", "-p" ,"/var/run/pcscd" )
   cmd_mkdir.Run()

       _cmdArgs := [] string{"-f",}
   var cmdArgs [] string

   if arguments == "--debug" {
      fmt.Println("pcscd DebugMode Start")
      cmdArgs = append(_cmdArgs, "--debug")
   } else {
      fmt.Println("pcscd Start")
   }

   cmd_pcscd := exec.Command("pcscd",cmdArgs...)
   if arguments == "--debug" {
      cmd_pcscd.Stdout = os.Stdout
      cmd_pcscd.Stderr = os.Stderr
   }
   cmd_pcscd.Start()

   cmd_socat := exec.Command("socat", "tcp-listen:40774,fork,reuseaddr" ,"unix-connect:/var/run/pcscd/pcscd.comm" )
   fmt.Println("socat Start - unix-connect:/var/run/pcscd/pcscd.comm - tcp-listen:40774")
   cmd_socat.Run()
 }