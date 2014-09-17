#ifndef __PTREE_XML_HPP__
#define __PTREE_XML_HPP__
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
template <typename type, typename NewType, typename AddChild, typename SetProperty>
type walkPTree(const boost::property_tree::ptree& tree, NewType newfunc, AddChild addfunc, SetProperty setfunc)
{
	type root=newfunc();
	for(auto &child:tree)
	{
		if (child.second.size()>0)
		{
			addfunc(root,walkPTree<type,NewType,AddChild,SetProperty>(child.second,newfunc,addfunc,setfunc));
		}
		else
		{
			std::string key=child.first.data();
			std::string value=child.second.data();
			setfunc(root,key,value);
		}
	}
	return root;
}
/* loadXML: load an XML file and set data into a tree-like object
 * type: node type
 * NewType: function to create a node
 * AddChild: function to append child node(2nd param) into parent node(1st param)
 * SetProperty: function to set member data of the node(1st param) according to the key and value
 */
template <typename type, typename NewType, typename AddChild, typename SetProperty>
type loadXML(const std::string& filename, NewType newfunc, AddChild addfunc, SetProperty setfunc)
{
	boost::property_tree::ptree pt;
	read_xml(filename,pt);
	return walkPTree<type,NewType,AddChild,SetProperty>(pt,newfunc,addfunc,setfunc);
}
#endif
