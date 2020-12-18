/* getlevel0data_plugin.h
 * a plugin to get level 0 data
 * 10/10/2018 : by Yang Yu
 */
 
#ifndef __NEURONRECON_PLUGIN_H__
#define __NEURONRECON_PLUGIN_H__

#include <QtGui>
#include <v3d_interface.h>

class GetLevel0DataPlugin : public QObject, public V3DPluginInterface2_1
{
	Q_OBJECT
	Q_INTERFACES(V3DPluginInterface2_1);

public:
    float getPluginVersion() const {return 1.01f;}

	QStringList menulist() const;
	void domenu(const QString &menu_name, V3DPluginCallback2 &callback, QWidget *parent);

	QStringList funclist() const ;
	bool dofunc(const QString &func_name, const V3DPluginArgList &input, V3DPluginArgList &output, V3DPluginCallback2 &callback, QWidget *parent);
};

#endif

