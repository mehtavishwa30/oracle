# oracle
A smart contract written in Sway to provide asset prices to blockchain applications. 

- Initialise owner of a certain asset
- Let owner set an order limit
- Monitor asset prices by retrieving current price and updating the storage with newly tracked price with timestamp
- If asset price is equal to or exceeds order limit set by owner, withdraw funds.
- Get number of tokens by asset ID
- Get remaining balance of funds after withdrawal