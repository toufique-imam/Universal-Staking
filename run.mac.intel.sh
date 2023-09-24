npm install --global @remix-project/remixd
echo "===================| Flattening StakingContract.sol |==================="
rm -rf contracts/StakingContractFlattened.sol
npx hardhat flatten contracts/StakingContract.sol > contracts/StakingContractFlattened.sol
echo "===================| Removing previous artifacts |==================="
rm -rf ./artifacts
rm -rf ./cache
echo "===================| Compiling |==================="
mkdir backup
mv contracts/StakingContract.sol backup/StakingContract.sol
npx hardhat compile
echo "===================| run the solt write contracts -r 200 if next command fails |==================="
chmod +x ./solt-mac 
./solt-mac write contracts -r 200
mv backup/StakingContract.sol contracts/StakingContract.sol
echo "===================| generated solc-input-contracts.json |==================="
echo "===================| Deploy the contracts using remix |==================="
npx remixd -s . -u https://remix.ethereum.org/