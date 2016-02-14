# Binary Reader
This script is capable of reading recursively a bunch of .dat files in binary format and generate a new 3-Dimensional structure containing the data associate to different particles.<br />
The data is organized into _n_-layers of the following 2-Dimensional structure:
<table>
  <tr>
    <td></td>
    <td colspan="8" style="text-align: right">1</td>
    <td>...</td>
    <td colspan="8" style="text-align: right">31</td>
  </tr>
  <tr>
    <td></td>
    <td>0</td>
    <td>3</td>
    <td>6</td>
    <td>9</td>
    <td>12</td>
    <td>15</td>
    <td>18</td>
    <td>21</td>
    <td>...</td>
    <td>0</td>
    <td>3</td>
    <td>6</td>
    <td>9</td>
    <td>12</td>
    <td>15</td>
    <td>18</td>
    <td>21</td>
  </tr>
  <tr>
    <td>lon</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>...</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>lat</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>...</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>h</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>...</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>qvi</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>...</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>theta</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>...</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>
Where each of the 2-Dimensional structures represents the data associated to an unique particle, the columns are organized into 8 steps during each day of the month (gives a total of 248 time steps). And each one of the rows represent an attibute of the particle at specific moment.

##### Input
- (Required) dirName: Path of the directory that contains the files and path to save the output files (cell array)

##### Output (13 files)
- log file: File that contains the list of property processed .dat files and the errors.
- [Month-Name].nc file: Files that contain a 3-Dimensional structure with the rearranged data read from the .dat files.

##### Function invocation
Reads all the .dat files from _SOURCE_PATH_ and generates rearranged the data into a single 3-Dimensional structure
```matlab
binary_reader({'SOURCE_PATH','SAVE_PATH'})
```
