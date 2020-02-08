if [[ -z $Z3_VERSION_TAG ]]; then
    Z3_VERSION_TAG=master
fi

# Check git status and make sure we don't modify the working tree with update changes by mistake
if [[ "${@#-force}" = "$@" && -n $(git status --porcelain) ]]; then
    echo "Current git repo's state is not committed! Please commit and try again."
    exit 1
fi

echo "Creating temporary path folder ./temp..."

if [[ -d "temp" ]]; then
    rm -rf temp
fi

mkdir temp

cd temp

if [[ $Z3_VERSION_TAG = "master" ]]; then
    git clone https://github.com/Z3Prover/z3.git --depth=1
else
    git clone https://github.com/Z3Prover/z3.git
fi

# Checkout proper Z3 version
cd z3
git checkout $Z3_VERSION_TAG

# Run some pre-build configurations first
python scripts/mk_make.py
cd ..

# Copy all Z3 files over
echo "Copying over Z3 files..."

mkdir z3/src/include
cp -R ../Sources/CZ3/include/* z3/src/include/
rm -R ../Sources/CZ3
mkdir ../Sources/CZ3

if [[ -d z3/src ]] && cp -R -p z3/src/* ../Sources/CZ3; then
    true
else
    echo "Error while copying over Z3 files: Could not locate source files path."
    exit 1
fi

# Remove language APIs and other extra files
echo "Removing extra files..."
rm -r ../Sources/CZ3/api/c++
rm -r ../Sources/CZ3/api/dotnet
rm -r ../Sources/CZ3/api/java
rm -r ../Sources/CZ3/api/ml
rm -r ../Sources/CZ3/api/python
rm -r ../Sources/CZ3/shell
rm -r ../Sources/CZ3/test
find ../Sources/CZ3 -name "CMakeLists.txt" -exec rm -rf {} \;

cd ..

rm -rf temp

echo "Success!"

if [[ -n $(git status --porcelain) ]]; then
    echo "New unstaged changes:"
    git status --porcelain
fi
