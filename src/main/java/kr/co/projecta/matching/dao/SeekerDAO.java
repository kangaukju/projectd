package kr.co.projecta.matching.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import kr.co.projecta.matching.log.Plogger;
import kr.co.projecta.matching.user.Seeker;

@Component("SeekerDAO")
public class SeekerDAO 
	extends LoggingDAO 
	implements DAO<Seeker> 
{	
	transient Plogger log = Plogger.getLogger(this.getClass());

	// 구직자 조회
	public Map selectMap(Map<String, Object> params) {
		return super.selectMap("seeker.select", params, "id");
	}
	
	// 구직자 조회
	public List<Seeker> selectList(Map<String, Object> params) {
		return super.selectList("seeker.select", params);
	}
	
	// 미배정된 구직자 조회 수
	public long selectNotAssignSeekerCount(Map<String, Object> params) {
		return super.selectCount("selectNotAssignSeekerCount", params);
	}
	
	// 미배정된 구직자 조회
	public List<Seeker> selectNotAssignSeeker() {
		return this.selectNotAssignSeeker(null);
	}
	public List<Seeker> selectNotAssignSeeker(Map<String, Object> params) {
		return super.selectList("seeker.selectNotAssignSeeker", params);
	}
	
	// 구직자 수 조회
	public long selectCount(Map<String, Object> params) {
		return super.selectCount("seeker.selectCount", params);
	}

	// 구직자 단일 조회
	public Seeker selectOne(String key, String value) {
		Map<String, Object> params = new HashMap<>();
		params.put(key, value);
		
		Seeker seeker = (Seeker) super.selectOne("seeker.selectOne", params);
		return seeker;
	}
	
	public Seeker selectOne(String seekerId) {
		return this.selectOne("id", seekerId);
	}
	
	// 구직자 회원가입
	public void join(Map<String, Object> params) {
		super.insert("seeker.join", params);
	}
	
	// 구직자 회원가입
	public void join(Seeker seeker) {
		super.insert("seeker.join", seeker);
	}
}
