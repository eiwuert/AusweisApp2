/*!
 * StartPaosResponse.h
 *
 * \brief Class represents the retrieved PAOS StartPaosResponse
 *
 * \copyright Copyright (c) 2014 Governikus GmbH & Co. KG
 */

#pragma once

#include "paos/ElementDetector.h"
#include "paos/ResponseType.h"

#include <QByteArray>
#include <QString>

namespace governikus
{

class StartPaosResponse
	: public ResponseType
	, private ElementDetector
{
	private:
		QString mResultMajor, mResultMinor, mResultMessage;

	public:
		StartPaosResponse(const QByteArray& pXmlData);

	private:
		void parse();
		virtual bool handleFoundElement(const QString& pElementName, const QString& pValue, const QXmlStreamAttributes& pAttributes) override;
};

} /* namespace governikus */
