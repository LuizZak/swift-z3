from utils.data.compound_symbol_name import CompoundSymbolName


class SymbolNameGenerator:
    def generate_enum_name(self, name: str) -> CompoundSymbolName:
        raise NotImplementedError()

    def generate_enum_case(
        self, enum_name: CompoundSymbolName, enum_original_name: str, case_name: str
    ) -> CompoundSymbolName:
        raise NotImplementedError()

    def generate_struct_name(self, name: str) -> CompoundSymbolName:
        raise NotImplementedError()

    def generate_original_struct_name(self, name: str) -> CompoundSymbolName:
        raise NotImplementedError()

    def generate_original_enum_name(self, name: str) -> CompoundSymbolName:
        raise NotImplementedError()

    def generate_original_enum_case(self, case_name: str) -> CompoundSymbolName:
        raise NotImplementedError()
