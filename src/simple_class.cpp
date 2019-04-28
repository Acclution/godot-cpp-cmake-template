#include "simple_class.h"

using namespace godot;

SimpleClass::SimpleClass() {}

/* _init must exist as it is called by Godot */
void SimpleClass::_init() {}

void SimpleClass::test_void_method() { Godot::print("This is test"); }

Variant SimpleClass::method(Variant arg)
{
	Variant ret;
	ret = arg;

	return ret;
}

void SimpleClass::_register_methods()
{
	register_method("method", &SimpleClass::method);

	/**
	 * How to register exports like gdscript
	 * export var _name = "SimpleClass"
	 **/
	register_property<SimpleClass, String>("base/name", &SimpleClass::_name, String("SimpleClass"));

	/* or alternatively with getter and setter methods */
	register_property<SimpleClass, int>("base/value", &SimpleClass::set_value, &SimpleClass::get_value, 0);

	/** For registering signal **/
	// register_signal<SimpleClass>("signal_name");
	// register_signal<SimpleClass>("signal_name", "string_argument", GODOT_VARIANT_TYPE_STRING)
}

void SimpleClass::set_value(int p_value) { _value = p_value; }

int SimpleClass::get_value() const { return _value; }
