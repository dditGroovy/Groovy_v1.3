package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;

@Getter
@Setter
@ToString
public class SalaryVO {
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="MM")
    private Date salaryPymntDate;
    private String salaryEmplId;
    private int salaryBslry; // 통상임금(월급)
//    private String totalOverTime; // 연장근로 시간
    private int salaryOvtimeAllwnc; // 시간외수당

}
