/**
@mainpage Main Page

@section main_intro Introduction

IRootLab is a framework for vibrational spectroscopy data analysis in MATLAB. It provides pattern recognition, biomarker extraction,
imaging, pre-processing methods etc, directed to vibrational spectroscopy (Fourier-Transform InfraRed (FTIR) and Raman).

The framework includes a class function library and a number of Graphical User Interfaces (GUIs) to import and analyse data
(@c objtool, @c mergetool, @c sheload). The @c objtool GUI can be used as a MATLAB code generator.
A demonstration page can be opened through @c browse_demos.

IRootLab is Free/Libre and Open-Source software, released under the LGPL licence.

Official website: http://irootlab.googlecode.com

@section thisdoc This Website

This is a file reference. For a friendly start to IRootLab, please check below or at http://code.google.com/p/irootlab/downloads/list.

This Doxygen-generated website is the official documentation of the IRootLab class and function library (*.m).
This documentation contains reference pages on individual .m files within the IRootLab directory.
It can be consulted by direct search (top right), or navigation (left). IRootLab classes are hierarchically organized (left). All files inside the "misc" directory, and some others, have been tentatively grouped into "modules" (left).

The online version of this site (at http://bioph.lancs.ac.uk/irootlabdoc) is accessed by IRootLab for reference, for example:
@arg Typing <code>help2('filename')</code> launchs a web browser with corresponding reference page on 'filename.m'.
@arg Pressing F1 at any GUI will launch the reference page on the source code of the GUI.


@section gettingstarted Quick getting started

<ol>
  <li> Download the most recent ZIP file from http://code.google.com/p/irootlab/downloads/list and extract the file into a directory of your choice
  <li> Start MATLAB </li>
  <li> Change MATLAB's "Current directory" to the one created above (which should contain a file called "startup.m")</li>
  <li> In MATLAB's command line, enter
@code
startup
@endcode
This sets the MATLAB path.</li>
  <li> The welcome message gives some commands/(options to click on): objtool, mergetool, browse_demos, sheload etc</li>
</ol>

@subsection gettingstarted_requirements IRootLab System requirements

MATLAB (Windows/Linux/MacOS/etc), release >= r2007b tested

@subsection gettingstarted_requirements Requirements for specific features

Some routines contain "parfor" loops to speed up the process. To parallelize computation using parfor, the MATLAB Parallel Computing Toolbox (PCT)
must be present. All routines that contain parfor loops can also run in serial mode without using the PCT.

Wavelet de-noising: this feature makes function calls to MATLAB Wavelet Toolbox.

@subsection gettingstarted_binaries Platform-specific binaries

@arg SVM classifier (LibSVM): LibSVM was successfully compiled for Windows 32-bit/Windows 64-bit; Linux 32-bit/64-bit.
@arg MySQL connector (mYm): mYm was currently compiled Windows 32-bit; Linux 32-bit/64-bit. Linux 64-bit: libmysqlclient.so.16 and  libmysqlclient.so.18.
*/
