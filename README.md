# PCM-and-DM-modulators

A Python/MATLAB project which implements pulse-code modulation (PCM) and delta modulation (DM).

This project was assigned for the Communication Engineering (EE 374) course in the Spring 2022 semester.



## Description

Consider the message signal m(t) = −cos(200πt) + sin(50πt).

- **Task 1: Pulse Code Modulation:** Consider the message signal m(t) for the
    time interval (0,2) seconds. Obtain the pulse code modulated binary sequence if the signal is
    sampled at the Nyquist sample rate and L=128 quantization levels are used. You can start
    labeling the quantization labels from the top. The first sample is taken at t=Ts. Your code
    should display the binary representation of the first 10 samples on the screen, in the format
    “0110011-1010010-... ”.
- **Task 2: Delta Modulation:** Consider the message signal m(t) for the time interval
    (0,2) seconds. Obtain the delta modulated binary sequence if the signal is sampled at four
    times the Nyquist sample rate. The first sample is taken at t=Ts. Your code should display
    the binary representation of the first 20 samples on the screen.



## Figures

### Delta Modulation (DM)

#### Python

<p align="left">
  <img alt="Figure" src="https://raw.githubusercontent.com/arasgungore/PCM-and-DM-modulators/main/Figures/python_DM.jpg" width="800">
</p>

#### MATLAB

<p align="left">
  <img alt="Figure" src="https://raw.githubusercontent.com/arasgungore/PCM-and-DM-modulators/main/Figures/matlab_DM.jpg" width="800">
</p>



## Run on Terminal

```sh
matlab -nodisplay -nosplash -nodesktop -r "run('main.m');exit;"
```



## Author

👤 **Aras Güngöre**

* LinkedIn: [@arasgungore](https://www.linkedin.com/in/arasgungore)
* GitHub: [@arasgungore](https://github.com/arasgungore)
