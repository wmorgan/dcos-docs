---
UID: 56f9844a74f88
post_title: Installing the CLI
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
*   [Installing the DCOS CLI on Unix, Linux, and OS X][1]
*   [Installing the DCOS CLI on Windows][2]

# <a name="linux"></a>Installing on Unix, Linux, and OS X

The easiest way to install the DCOS CLI is by clicking the signpost icon in the lower left corner of the DCOS web interface. Or, you can manually install the CLI by following these instructions.

#### Prerequisites

*   A system external to your DCOS cluster that you can install the CLI
*   Network access from the external system to your DCOS cluster
*   A command-line environment, such as Terminal
*   cURL: Installed by default on OS X and most Linux distributions.
*   Python 2.7.x or 3.4.x: Installed by default on OS X and most Linux distributions. (Python 3.5.x will not work.)
*   Pip: See the <a href="https://pip.pypa.io/en/stable/installing.html#install-pip" target="_blank">installation documentation</a>.
*   Git: 
    *   **OS X:** Get the installer from [Git downloads][3].
    *   **Unix/Linux:** See these <a href="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git" target="_blank">installation instructions</a>.

#### Installing the DCOS CLI

1.  Install **virtualenv**:
    
        $ sudo pip install virtualenv
        
    
    **Tip:** On some older Python versions, you might receive an "Insecure Platform" warning, but you can safely ignore this. For more information, see <a href="https://virtualenv.pypa.io/en/latest/installation.html" target="_blank">https://virtualenv.pypa.io/en/latest/installation.html</a>.

2.  From the command line, create a new directory named `dcos` and change your working directory to it.
    
        $ mkdir dcos && cd dcos
        

3.  Download the DCOS CLI install script to your new directory:
    
        $ curl -O https://downloads.mesosphere.io/dcos-cli/install.sh
        

4.  Run the DCOS CLI install script, where `<installdir>` is the DCOS installation directory and `<hosturl>` is the hostname of your master node prefixed with `http://`:
    
        $ bash install.sh <install_dir> http://<hosturl>
        
    
    For example, if the hostname of your AWS master node is `dcos-ab-1234.us-west-2.elb.amazonaws.com`:
    
        $ bash install.sh . http://dcos-ab-1234.us-west-2.elb.amazonaws.com
        

5.  Follow the on-screen DCOS CLI instructions. You can ignore any Python "Insecure Platform" warnings.
    
    You can now use the CLI.
    
        Command line utility for the Mesosphere Datacenter Operating 
        System (DCOS). The Mesosphere DCOS is a distributed operating 
        system built around Apache Mesos. This utility provides tools 
        for easy management of a DCOS installation.
        
        Available DCOS commands:
        
            config Get and set DCOS CLI configuration properties 
            help Display command line usage information 
            marathon Deploy and manage applications on the DCOS 
            node Manage DCOS nodes 
            package Install and manage DCOS packages 
            service Manage DCOS services 
            task Manage DCOS tasks
        
        Get detailed command description with 'dcos <command> --help'.
        

# <a name="windows"></a>Installing on Windows

#### Prerequisites

*   A system external to your DCOS cluster onto which you will install the CLI
*   Network access from the external system to your DCOS cluster
*   Windows PowerShell: Installed by default on Windows 7 and later

To install the DCOS CLI, you must first install Python, pip, Git, and virtualenv.

**Important:** Disable any security or antivirus software before beginning the installation.

#### Installing Python

1.  Download the Python 2.7 or Python 3.4 installer <a href="https://www.python.org/downloads/windows/" target="_blank">here</a>.
    
    **Important:** You must use Python version 2.7.x or 3.4.x. Python version 3.5.x will not work with the DCOS CLI. Use the x86-64 installer for 64-bit versions of Windows and the x86 installer for 32-bit versions of Windows.

2.  Run the installer and select the "Add python.exe to Path" option when you are prompted to "Customize Python" as shown in the screenshot below.
    
    <a href="/wp-content/uploads/2016/01/python.png" rel="attachment wp-att-2944"><img src="/wp-content/uploads/2016/01/python.png" alt="Python Installer with Path Option Selected" width="495" height="427" class="alignnone size-full wp-image-2944" /></a>
    
    **Important:** If you do not select the "Add python.exe to Path" option, you must manually add the Python installation folder to your Path or the DCOS CLI will not work.

#### Upgrading pip

Pip is included with Python, but you must upgrade pip for it to work properly with the DCOS CLI.

1.  Download the `get-pip.py` script from <a href="https://pip.pypa.io/en/stable/installing.html#install-pip" target="_blank">the pip download page</a>.

2.  Run Powershell as Administrator by right-clicking the Start menu shortcut as shown in the screenshot below:
    
    <a href="/wp-content/uploads/2016/01/powershell.png" rel="attachment wp-att-2943"><img src="/wp-content/uploads/2016/01/powershell.png" alt="Start Menu with &#039;Launch as Administrator&#039; Option Highlighted" width="392" height="622" class="alignnone size-full wp-image-2943" /></a>
    
    **Important:** You must run Powershell as Administrator or the CLI installation will fail.

3.  Run the script.
    
        PS C:\> python get-pip.py
        

#### Installing Git

1.  Download the Git installer from <a href="http://git-scm.com/download/win" target="_blank">the Git download page</a>.

2.  Run the installer.
    
    **Tip:** You might receive a security warning that blocks execution of the installer and states that "Windows protected your PC." It is safe to ignore this warning and click "Run Anyway."

3.  During the Git install, select the "Use Git from the Windows Command Prompt" option when you are prompted as shown in the screenshot below.
    
    <a href="/wp-content/uploads/2016/01/git.png" rel="attachment wp-att-2945"><img src="/wp-content/uploads/2016/01/git.png" alt="Git Installer with Windows Command Prompt Option Enabled" width="499" height="387" class="alignnone size-full wp-image-2945" /></a>
    
    **Important:** If you do not select the "Use Git from the Windows Command Prompt" option, you must manually add the Git installation folder to your Path or the DCOS CLI will not work.

#### Installing virtualenv

1.  Run Powershell as Administrator.

2.  Install `virtualenv`:
    
        PS C:\> pip install virtualenv
        
    
    **Tip:** You can safely ignore any Python "Insecure Platform" warnings. For more information, see <a href="https://virtualenv.pypa.io/en/latest/installation.html" target="_blank">https://virtualenv.pypa.io/en/latest/installation.html</a>.

#### Installing the CLI

1.  Run Powershell as Administrator.

2.  From the command line, create a new directory named `dcos` (it can be located wherever you wish) and change your working directory to it.
    
        PS C:\> md dcos
        
        
        Directory: C:\
        
        
        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        d-----        1/29/2016   2:33 PM                dcos
        
        
        PS C:\> cd dcos
        PS C:\dcos>
        

3.  Download the DCOS CLI Powershell install script [by clicking here][4]. Save the script to the `dcos` directory.
    
    If you are running Windows 10, or if you are running an earlier version of Windows and have manually installed the `wget` software package, you can alternatively download the Powershell script directly from within Powershell:
    
        PS C:\dcos\> wget https://downloads.mesosphere.io/dcos-cli/install.ps1 -OutFile install.ps1
        

4.  Change the default security policy of your Powershell to allow the install script to run:
    
        PS C:\dcos> set-executionpolicy Unrestricted -Scope Process
        
        Execution Policy Change
        The execution policy helps protect you from scripts that you do not trust. 
        Changing the execution policy might expose you to the security risks 
        described in the about_Execution_Policies help topic at
        http://go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the 
        execution policy?
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help 
        (default is "N"): Y
        

5.  Run the DCOS CLI install script, where `<installdir>` is the DCOS installation directory and `<hosturl>` is the hostname of your master node prefixed with `http://`:
    
        PS C:\dcos\> .\install.ps1 <install_dir> <hosturl>
        
    
    For example, if the hostname of your AWS master node is `dcos-ab-1234.us-west-2.elb.amazonaws.com`:
    
        PS C:\dcos\> .\install.ps1 . http://dcos-ab-1234.us-west-2.elb.amazonaws.com
        
    
    **Tip:** You might receive a security warning. It is safe to ignore this warning and allow the script to run:
    
        Security Warning
        Run only scripts that you trust. While scripts from the Internet can
        be useful, this script can potentially harm your computer. Do you
        want to run C:\dcos\install.ps1?
        [D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R
        

6.  Enter the Mesosphere verification code when prompted or hit ENTER to continue. You can ignore any Python "Insecure Platform" warnings.

7.  Follow the on-screen DCOS CLI instructions to add the `dcos` command to your PATH and complete installation:
    
        PS C:\dcos\> & .activate.ps1; dcos help
        
    
    You can now use the CLI.
    
        Command line utility for the Mesosphere Datacenter Operating 
        System (DCOS). The Mesosphere DCOS is a distributed operating 
        system built around Apache Mesos. This utility provides tools 
        for easy management of a DCOS installation.
        
        Available DCOS commands:
        
            config Get and set DCOS CLI configuration properties 
            help Display command line usage information 
            marathon Deploy and manage applications on the DCOS 
            node Manage DCOS nodes 
            package Install and manage DCOS packages 
            service Manage DCOS services 
            task Manage DCOS tasks
        
        Get detailed command description with 'dcos <command> --help'.

 [1]: #linux
 [2]: #windows
 [3]: http://git-scm.com/download/mac
 [4]: https://downloads.mesosphere.io/dcos-cli/install.ps1