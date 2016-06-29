python setup.py install --single-version-externally-managed --record record.txt
gendef.exe %PREFIX%\python%CONDA_PY%.dll
dlltool.exe --dllname python%CONDA_PY%.dll --def python%CONDA_PY%.def --output-lib %PREFIX%\libs\libpython%CONDA_PY%.a
