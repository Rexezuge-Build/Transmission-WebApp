#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#define likely(x) __builtin_expect((x), 1)
#define unlikely(x) __builtin_expect((x), 0)

void runService_Transmission(void) {
  // Start Transmission Web Server
  printf("\033[0;32m%s\033[0m%s\n",
         "INFO: ", "Starting Transmission Web Server");
  fflush(stdout);

  pid_t pidTransmission = fork();
  if (unlikely(pidTransmission == -1)) {
    printf("\033[0;31m%s\033[0m%s\n", "ERROR: ", "Failed to Fork");
    exit(EXIT_FAILURE);
  } else if (pidTransmission == 0) {
    fclose(stdin);
    freopen("/dev/null", "w", stdout);
    freopen("/dev/null", "w", stderr);
    execl("/usr/bin/transmission-daemon", "transmission-daemon", "--foreground",
          "--config-dir", "/etc/transmission-daemon", NULL);
    exit(EXIT_FAILURE);
  }
}

int main(void) {
  // Refuse to Start as Non-Pid=1 Program
  if (getpid() != 1) {
    printf("\033[0;31m%s\033[0m%s\n", "ERROR: ", "Must be Run as PID 1");
    exit(EXIT_FAILURE);
  }

  // Set Environment Variable
  putenv("TRANSMISSION_WEB_HOME=/.TransmissionWebControl");

  runService_Transmission();

  // Collect Zombine Process
  while (1) {
    waitpid(-1, NULL, 0);
  }

  return EXIT_SUCCESS;
}
