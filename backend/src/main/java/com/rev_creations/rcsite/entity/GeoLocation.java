package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Immutable;

/**
 * MaxMind GeoIP location rows. The table has no declared primary key; the
 * {@code id} column (the MaxMind location id) is unique in practice and is used
 * here purely as a read-only identifier. Never written.
 */
@Entity
@Table(name = "geo_location")
@Immutable
@Getter
@Setter
public class GeoLocation {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "location_id")
    private Long locationId;

    @Column(name = "country")
    private String country;

    @Column(name = "region")
    private String region;

    @Column(name = "city")
    private String city;

    @Column(name = "postal_code")
    private String postalCode;

    @Column(name = "latitude")
    private Float latitude;

    @Column(name = "longitude")
    private Float longitude;

    @Column(name = "metro_code")
    private Long metroCode;

    @Column(name = "area_code")
    private Long areaCode;
}
