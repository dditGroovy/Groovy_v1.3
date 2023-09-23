package kr.co.groovy.salary;

import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vo.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface SalaryMapper {

    List<AnnualSalaryVO> loadSalary();

    List<AnnualSalaryVO> loadBonus();

    List<TariffVO> loadTariff(@Param("year") String year);

    List<EmployeeVO> loadEmpList();

    List<SalaryVO> loadPaymentList(@Param("emplId") String emplId, @Param("year") String year);

    PaystubVO loadRecentPaystub(String emplId);

    List<Integer> loadYearsForSortPaystub(String emplId);

    List<PaystubVO> loadPaystubList(@Param("emplId") String emplId, @Param("year") String year);

    void modifyIncmtax(@Param("code") String code, @Param("value") double value);

    void modifySalary(@Param("code") String code, @Param("value") double value);

    PaystubVO loadPaystubDetail(@Param("emplId") String emplId, @Param("paymentDate") String paymentDate);

    List<String> getExistsYears();

    List<String> getExistsMonthByYear(String year);

    List<CommuteVO> getCommuteByYearAndMonth(String date);

    String getPrescribedWorkingHours(String date);

    List<PaystubVO> getSalaryBslry(String date);

    List<CommuteVO> getCoWtrmsAbsenc(String date);

    int inputSalary(PaystubVO vo);

    int inputSalaryDtsmt(PaystubVO vo);

    int isInsertSalary(Map<String, String> map);
    int isInsertSalaryDtsmt(Map<String, String> map);
}
