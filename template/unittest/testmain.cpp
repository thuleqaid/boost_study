#define BOOST_TEST_MODULE TestSuitName
#include <boost/test/unit_test.hpp>
/* include test case file */
/* struct FixStruct
 * {
 *   FixStruct();
 *   ~FixStruct();
 *   Type member; // can be used in the test case
 * };
 * BOOST_AUTO_TEST_SUITE(test_suite_name)/BOOST_FIXTURE_TEST_SUITE(test_suite_name, DefaultFixStruct)
 * BOOST_GLOBAL_FIXTURE( GlobalFixStruct );
 * BOOST_AUTO_TEST_CASE(test_case_name_1)
 * {
 *   BOOST_CHECK( bool-exp );
 *   BOOST_REQUIRE( bool-exp ); // exit on failure
 *   BOOST_ERROR( failure-msg );
 *   BOOST_FAIL( failure-msg ); // exit on failure
 *   BOOST_CHECK_MESSAGE( bool-exp, failure-msg );
 *   BOOST_CHECK_EQUAL( first-value, second-value );
 * }
 * BOOST_FIXTURE_TEST_CASE(test_case_name_2, LocalFixStruct)
 * {
 * }
 * BOOST_AUTO_TEST_SUITE_END()
 * // Fixture Running Flow:
 * //   GlobalFixStruct()                     for test-suite
 * //   DefaultFixStruct()/LocalFixStruct()
 * //   TEST_CASE-1
 * //   ~DefaultFixStruct()/~LocalFixStruct()
 * //   DefaultFixStruct()/LocalFixStruct()
 * //   TEST_CASE-2
 * //   ~DefaultFixStruct()/~LocalFixStruct()
 * //   ~GlobalFixStruct()                    for test-suite
 */
