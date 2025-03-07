# Credit to https://github.com/foolnotion/nur-pkg/blob/master/pkgs/vectorclass/default.nix

# TODO(breakds): fork vectorclass version 2 and add proper CMakeLists.txt to it.

{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "vectorclass";
  version = "2.02.01";

  src = fetchFromGitHub {
    owner = "vectorclass";
    repo = "version2";
    rev = "v${version}";
    sha256 = "sha256-45qt0vGz6ibEmcoPZDOeroSivoVnFkvMEihjXJXa8lU=";
  };

  installPhase = ''
    mkdir -p $out/include/vectorclass
    mkdir -p $out/share/vectorclass
    cp *.h $out/include/vectorclass
    cp ${./vectorclass-cmake}/* $out/share/vectorclass/
  '';

  postFixup = ''
        mkdir -p $out/lib/pkgconfig
        echo "
    prefix=$out/include/vectorclass
    includedir=$out/include/vectorclass

    Name: Vectorclass
    Description: C++ class library for using the Single Instruction Multiple Data (SIMD) instructions to improve performance on modern microprocessors with the x86 or x86/64 instruction set.
    Version: $version
    Cflags: -I$out/include/vectorclass" > $out/lib/pkgconfig/vectorclass.pc

        sed -i "s|VECTORCLASS_INCLUDE_DIR|$out/include|g" $out/share/vectorclass/vectorclassTargets.cmake
  '';

  meta = with lib; {
    description =
      "C++ class library for using the Single Instruction Multiple Data (SIMD) instructions to improve performance on modern microprocessors with the x86 or x86/64 instruction set";
    homepage = "https://github.com/vectorclass/version2";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ breakds ];
  };
}
