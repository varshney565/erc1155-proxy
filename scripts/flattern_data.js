const { ethers } = require("hardhat");
const abi = require("ethereumjs-abi");

// Sample data
const data = [
  {
    uri: "hello world",
    detail: [
      { to : "0x4A4E870F13f3F3568B2A1f392BC2735a25947E8F",amount : 123 }
    ]
  },
  {
    uri: "hello world",
    detail: [
      { to : "0x4A4E870F13f3F3568B2A1f392BC2735a25947E8F",amount : 123 }
    ]
  }
];

const flattenedData = data.flatMap(({ uri, detail }) => [
  uri,
  detail.flatMap(({ to, amount }) => [to, amount])
]);

// Define the types for ABI encoding
const types = ["string", "address", "uint256"];

// Encode the flattened data
const encodedData = "0x" + abi.rawEncode(types, flattenedData).toString("hex");

console.log("Encoded Data:", encodedData);