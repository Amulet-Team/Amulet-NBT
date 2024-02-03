from libcpp.string cimport string

ctypedef string (*CStringEncode)(const string&)
ctypedef string (*CStringDecode)(const string&)
