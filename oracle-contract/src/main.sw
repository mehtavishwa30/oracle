contract;

dep data_structures;

use data_structures::Price;
use sway_libs::storagemapvec::StorageMapVec;
use std::{
    auth::msg_sender,
    revert::require,
    logging::log,
}

// abi declaration

abi Oracle {
    #[storage(read)]
    fn owner() -> Identity;

    #[storage(read, write)]
    fn initialise(owner: Address);

    #[storage(read, write)]
    fn set_price(id: ContractID, price: u64);

    #[storage(read)]
    fn get_price(id: ContractID) -> Price;

    #[storage(read)]
    fn owner_auth();
} 

storage{
    prices: storageMap<ContractID, Price> = storageMap{},
    owner: Address = Address::from(address_zero),
}

// abi implementation

impl Oracle for Contract {
    #[storage(read)]
    fn owner() -> Identity{
        Identity::Address(storage.owner)
    }

    #[storage(read, write)]
    fn initialise(owner: Address){
        owner = storage.owner;
    }

    #[storage(read, write)]
    fn set_price(id: ContractID, price: u64){

        #[storage(read)]
        fn owner_auth(){
            let user = get_user_address;
            require(storage.owner == user , "User not authorised to access asset price.")
        }
        
        fn get_user_address() -> Address {
            let user = Result<Identity, AuthError> = msg_sender();
            if let Identity::Address(Address) = user.unwrap(){
                address
            }
            else{
                revert(0);
            }
        }

        storage.prices.push(id, Price{ id, price });

    }

    #[storage(read)]
    fn get_price(id: ContractID) -> Price { storage.prices.get(id) };
}
