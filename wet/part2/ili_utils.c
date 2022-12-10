#include <asm/desc.h>

// TO_DO: store the address of the IDT at the parameter given
void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL>
	asm volatile("sidt %0;"
                :"=m"(*idtr)
                :
                :
                );
// </STUDENT FILL>
}////

// TO_DO: load the address of the IDT from the parameter given
void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL>
	asm volatile("lidt %0;"
                :
                :"m"(*idtr)
                :
                );
// <STUDENT FILL>
}

// TO_DO: set the address in the right place at the parameter gate
// try to remember - how this information is stored?
void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
// <STUDENT FILL>
	gate->offset_low = addr;
    gate->offset_middle = addr >> 16;
    gate->offset_high = addr >> 32;
// </STUDENT FILL>
}

// TO_DO: return val is the address stored at the parameter gate_desc gate
// try to remember - how this information is stored?
unsigned long my_get_gate_offset(gate_desc *gate) {
// <STUDENT FILL>
	unsigned long address = gate->offset_high;
    address = address << 16;
    address += gate->offset_middle;
    address = address << 16;
    return address + gate->offset_low;
// </STUDENT FILL>
}
