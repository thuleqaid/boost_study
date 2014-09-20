/*!
 * \file translator.h
 * \brief Chinese calendar translator
 * \author thuleqaid@gmail.com
 * \version v0.1
 * \date 2014/09/20
 * \copyright MIT License
 */
#ifndef __TRANSLATOR_H__
#define __TRANSLATOR_H__

#ifdef __cplusplus
extern "C" {
#endif
	/*!
	 * \brief		translate an AD datetime into a Chinese Solar datetime
	 * \param[in]	adcal address of an array of AD calendar datetime, including year, month, day, hour, minute, second
	 * \param[out]	solarcal address of Chinese Solar calendar datetime, include year, month, day, hour
	 * \retval		0	translation success
	 * \retval		-1	pointer error
	 * \retval		-2	input datetime error
	 */
	int TranslateAD2Solar(short const * const adcal, short * const solarcal);
	/*!
	 * \brief		translate an AD datetime into a Chinese Lunar datetime
	 * \param[in]	adcal address of an array of AD calendar datetime, including year, month, day
	 * \param[out]	solarcal address of Chinese Solar calendar datetime, include year, month, day, is leap month(0:false,1:true)
	 * \retval		0	translation success
	 * \retval		-1	pointer error
	 * \retval		-2	input datetime error
	 */
	int TranslateAD2Lunar(short const * const adcal, short * const lunarcal);
	/*!
	 * \brief		translate a Chinese Lunar datetime into an AD datetime
	 * \param[in]	solarcal address of Chinese Solar calendar datetime, include year, month, day, is leap month(0:false,1:true)
	 * \param[out]	adcal address of an array of AD calendar datetime, including year, month, day
	 * \retval		0	translation success
	 * \retval		1	translation success(flag for leap month is ignored)
	 * \retval		-1	pointer error
	 * \retval		-2	input datetime error
	 */
	int TranslateLunar2AD(short const * const lunarcal, short * const adcal);
	/*!
	 * \brief		calculate seconds(adcal-JieQi(index))
	 * \param[in]	adcal	address of an array of AD calendar datetime, including year, month, day, hour, minute, second
	 * \param[in]	index	JieQi index, -5~0:last winter, 1~6:spring, 7~12:summer, 13~18:autumn, 19~24:winter, 25~30:next spring
	 * \return		diff in seconds
	 */
	long SecondsDiff(short const * const adcal, short index);
#ifdef __cplusplus
}
#endif

#endif

