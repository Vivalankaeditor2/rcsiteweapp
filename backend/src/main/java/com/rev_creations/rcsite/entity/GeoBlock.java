package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Immutable;

/** IP-range to location mapping (MaxMind). {@code loc_id} is a plain scalar id. */
@Entity
@Table(name = "geo_blocks")
@Immutable
@Getter
@Setter
public class GeoBlock {
    @Id
    @Column(name = "start_ip_num")
    private Long startIpNum;

    @Column(name = "end_ip_num")
    private Long endIpNum;

    @Column(name = "loc_id")
    private Long locationId;
}
