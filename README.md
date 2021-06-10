![CISL1-AL2-v1.0.0-hardening_logo](./images/CISL1-AL2-v1.0.0-hardening.png)

# CISL1-AL2-v1.0.0-hardening

A Bash script that tests and implements CIS Level 1 hardening benchmarks for Amazon Linux 2 based hosts.

More information about CIS and CIS standards can be accessed at [CIS Center for Internet Security](https://www.cisecurity.org/).

## General information

The script is going 1-by-1 through the 176 CIS Level 1 benchmarks for Amazon Linux 2 platform (a copy of the specs is included in the repo as PDF) and for each benchmark it audits the configuration and:
* If the configuration already satisfies the benchmark requirements, it marks the benchmark as a "Pass" and moves onto the next benchmark.
* If the configuration does not satisfy the benchmark requirements:
  - It performs the required corrective actions/configuration changes (using its root privileges).
  - Then it audits again the configuration requirements and:
    1. It confirms that the benchmark is now a Pass.
    2. It finds out that the benchmark requirements are still not met and shows a FAIL.

## Requirements

The script is meant to be run on a vanilla Amazon Linux 2 system and with admin (root) privileges. If either one of these conditions is not met, the script exits with exit code 1.

## Installation

Clone the GitHub repo and move into the `CIS_HARDENING_HOME` folder with:

```Bash
git clone https://github.com/StefanoRatto/CISL1-AL2-v1.0.0-hardening
cd CISL1-AL2-v1.0.0-hardening
export CIS_HARDENING_HOME=$(pwd)
```

## Usage

```Bash
cd $CIS_HARDENING_HOME
sudo ./CISL1-AL2-v1.0.0-hardening
```

## Licensing

The tool is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).
