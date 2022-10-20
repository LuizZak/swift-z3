from utils.data.compound_symbol_name import CompoundSymbolName
from utils.data.compound_symbol_name import ComponentCase


def convert_dxgi_enum_case(name: CompoundSymbolName, prefixes: list[str]) -> CompoundSymbolName:
    DECAPITALIZE=[
        'bias',
        'float',
        'force',
        'format',
        'sharedexp',
        'sint',
        'snorm',
        'typeless',
        'uint',
        'unknown',
        'unorm',

        # Multi-term strings
        *'sampler_feedback_min_mip_opaque'.split('_'),
        *'sampler_feedback_mip_region_used_opaque'.split('_'),
    ]

    common = CompoundSymbolName.from_snake_case('DXGI_FORMAT')
    (new_name, prefix) = name.removing_common(common)
    new_name = new_name.removing_prefixes(prefixes)

    # De-capitalize parts of the string
    for index, comp in enumerate(new_name):
        if comp.string.lower() in DECAPITALIZE:
            new_name[index] = comp.with_string_case(ComponentCase.LOWER)

    if prefix is not None:
        prefix = prefix.lower()
        return CompoundSymbolName(components=prefix.components + new_name.components)
    
    return new_name
