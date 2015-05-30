local s = require "serialize"

function recursive_compare(t1, t2)
	if t1==t2 then return true; end
	if type(t1)~="table" or type(t2)~="table" then return false; end
	
	for k1,v1 in pairs(t1) do
		local v2 = t2[k1];
		if not recursive_compare(v1,v2) then return false; end
	end
	for k2, v2 in pairs(t2) do
		local v1 = t1[k2];
		if not recursive_compare(v1,v2) then return false; end
	end
	
	return true;  
end

addressbook = {
	name = "Alice",
	id = 12345,
	phone = {
		{ number = "1301234567" },
		{ number = "87654321", type = "WORK" },
	}
}

local addressbook_filename = "addressbook.bin";
s.fwrite(addressbook, addressbook_filename);
local addressbook2 = s.fread(addressbook_filename);
assert(recursive_compare(addressbook, addressbook2));

s.fwrite(s.pack(addressbook), addressbook_filename);
local addressbook3 = s.unpack(s.fread(addressbook_filename));
assert(recursive_compare(addressbook, addressbook3));
assert(recursive_compare(addressbook2, addressbook3));
