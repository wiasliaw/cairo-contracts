// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.7.0 (introspection/src5.cairo)

#[starknet::contract]
mod SRC5 {
    use openzeppelin::introspection::interface;

    #[storage]
    struct Storage {
        SRC5_supported_interfaces: LegacyMap<felt252, bool>
    }

    mod Errors {
        const INVALID_ID: felt252 = 'SRC5: invalid id';
    }

    #[external(v0)]
    impl SRC5Impl of interface::ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            if interface_id == interface::ISRC5_ID {
                return true;
            }
            self.SRC5_supported_interfaces.read(interface_id)
        }
    }

    #[external(v0)]
    impl SRC5CamelImpl of interface::ISRC5Camel<ContractState> {
        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            SRC5Impl::supports_interface(self, interfaceId)
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn register_interface(ref self: ContractState, interface_id: felt252) {
            self.SRC5_supported_interfaces.write(interface_id, true);
        }

        fn deregister_interface(ref self: ContractState, interface_id: felt252) {
            assert(interface_id != interface::ISRC5_ID, Errors::INVALID_ID);
            self.SRC5_supported_interfaces.write(interface_id, false);
        }
    }
}

#[inline(always)]
fn unsafe_state() -> SRC5::ContractState {
    SRC5::unsafe_new_contract_state()
}
