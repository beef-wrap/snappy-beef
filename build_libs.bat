mkdir libs
mkdir libs\debug
mkdir libs\release

mkdir snappy\build
cd snappy\build

cmake ..

cmake --build .
copy Debug\snappy.lib ..\..\libs\debug
copy Debug\snappy.pdb ..\..\libs\debug

cmake --build . --config Release
copy Release\snappy.lib ..\..\libs\release